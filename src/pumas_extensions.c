#include <float.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "pumas_extensions.h"


/* Forward error messages to a buffer */
#define ERROR_SIZE 2048
static char last_error[ERROR_SIZE] = {0x0};

static void forward_error(int rc, void (*caller)(void), const char * message)
{
        strncpy(last_error, message, ERROR_SIZE);
}
#undef ERROR_SIZE

static void forward_error_gull(
    enum gull_return rc, gull_function_t * caller, const char * message)
{
        forward_error(rc, caller, message);
}

static void forward_error_pumas(
    enum pumas_return rc, pumas_function_t * caller, const char * message)
{
        forward_error(rc, caller, message);
}

static void forward_error_turtle(
    enum turtle_return rc, turtle_function_t * caller, const char * message)
{
        forward_error(rc, caller, message);
}


void pumas_error_initialise(void)
{
    gull_error_handler_set(forward_error_gull);
    pumas_error_handler_set(forward_error_pumas);
    turtle_error_handler_set(forward_error_turtle);
}


/* Manage the last error message */
void pumas_error_clear(void)
{
        last_error[0] = 0x0;
}

const char * pumas_error_get(void)
{
        return (last_error[0] == 0x0) ? NULL : last_error;
}


/* Set the MT initial state */
void pumas_random_initialise(
    struct pumas_context * context, unsigned long seed)
{
        struct pumas_user_data * user_data = context->user_data;
        struct pumas_random * data = &user_data->random;

        data->buffer[0] = seed & 0xffffffffUL;
        int j;
        for (j = 1; j < MT_PERIOD; j++) {
                data->buffer[j] = (1812433253UL *
                        (data->buffer[j - 1] ^ (data->buffer[j - 1] >> 30)) +
                    j);
                data->buffer[j] &= 0xffffffffUL;
        }
        data->index = MT_PERIOD;
}


/* Uniform pseudo random distribution from a Mersenne Twister */
double pumas_random_uniform01(struct pumas_context * context)
{
        struct pumas_user_data * user_data = context->user_data;
        struct pumas_random * data = &user_data->random;

        /* Check the buffer */
        if (data->index < MT_PERIOD - 1) {
                data->index++;
        } else {
                /* Update the MT state */
                const int M = 397;
                const unsigned long UPPER_MASK = 0x80000000UL;
                const unsigned long LOWER_MASK = 0x7fffffffUL;
                static unsigned long mag01[2] = { 0x0UL, 0x9908b0dfUL };
                unsigned long y;
                int kk;
                for (kk = 0; kk < MT_PERIOD - M; kk++) {
                        y = (data->buffer[kk] & UPPER_MASK) |
                            (data->buffer[kk + 1] & LOWER_MASK);
                        data->buffer[kk] =
                            data->buffer[kk + M] ^ (y >> 1) ^ mag01[y & 0x1UL];
                }
                for (; kk < MT_PERIOD - 1; kk++) {
                        y = (data->buffer[kk] & UPPER_MASK) |
                            (data->buffer[kk + 1] & LOWER_MASK);
                        data->buffer[kk] = data->buffer[kk + (M - MT_PERIOD)] ^
                            (y >> 1) ^ mag01[y & 0x1UL];
                }
                y = (data->buffer[MT_PERIOD - 1] & UPPER_MASK) |
                    (data->buffer[0] & LOWER_MASK);
                data->buffer[MT_PERIOD - 1] =
                    data->buffer[M - 1] ^ (y >> 1) ^ mag01[y & 0x1UL];
                data->index = 0;
        }

        /* Tempering */
        unsigned long y = data->buffer[data->index];
        y ^= (y >> 11);
        y ^= (y << 7) & 0x9d2c5680UL;
        y ^= (y << 15) & 0xefc60000UL;
        y ^= (y >> 18);

        /* Convert to a floating point and return */
        return y * (1.0 / 4294967295.0);
}


void pumas_state_extended_reset(struct pumas_state_extended * state,
    struct pumas_context * context)
{
        state->context = context;
        state->geodetic.computed = 0;
        state->vertical.distance = -1;
}


/* Setters and getters for the geometry */
struct pumas_geometry * pumas_geometry_get(struct pumas_context * context)
{
        struct pumas_user_data * user_data = context->user_data;
        return user_data->geometry.top;
}


void pumas_geometry_set(
    struct pumas_context * context, struct pumas_geometry * geometry)
{
        struct pumas_user_data * user_data = context->user_data;
        user_data->geometry.top = geometry;
}


static void geometry_reset(struct pumas_geometry * geometry)
{
        if (geometry->reset != NULL) geometry->reset(geometry);

        struct pumas_geometry * g;
        for (g = geometry->daughters; g != NULL; g = g->next)
                geometry_reset(g);
}


void pumas_geometry_reset(struct pumas_context * context)
{
        struct pumas_user_data * user_data = context->user_data;
        user_data->geometry.current = user_data->geometry.top;
        if (user_data->geometry.top != NULL)
                geometry_reset(user_data->geometry.top);
}


static void geometry_destroy(struct pumas_geometry * geometry)
{
        struct pumas_geometry * g;
        for (g = geometry->daughters; g != NULL; g = g->next)
                geometry_destroy(g);
        if (geometry->destroy != NULL) geometry->destroy(geometry);
}


void pumas_geometry_destroy(struct pumas_context * context)
{
        struct pumas_user_data * user_data = context->user_data;
        if (user_data->geometry.top != NULL) {
                geometry_destroy(user_data->geometry.top);
                user_data->geometry.top = NULL;
        }
        user_data->geometry.current = NULL;
}


void pumas_geometry_push(struct pumas_geometry * geometry,
    struct pumas_geometry * daughter)
{
        daughter->mother = geometry;

        if (geometry->daughters == NULL) {
                geometry->daughters = daughter;
        } else {
                struct pumas_geometry * last = geometry->daughters;
                while (last->next != NULL) last = last->next;
                last->next = daughter;
        }
}


/* The transparent medium, e.g. for bounding boxes */
static struct pumas_medium transparent_medium = { -1, NULL };
struct pumas_medium * PUMAS_MEDIUM_TRANSPARENT = &transparent_medium;


/* Recursive geometry navigation */
static void geometry_navigate(struct pumas_geometry * geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p, struct pumas_geometry * exclude,
    struct pumas_geometry ** current_p)
{
        if (geometry == NULL) return;

        geometry->get(geometry, state, medium_p, step_p);
        *current_p = geometry;

        struct pumas_state_extended * extended = (void *)state;
        struct pumas_user_data * user_data =
            (void *)extended->context->user_data;
        if (user_data->geometry.callback != NULL) {
                user_data->geometry.callback(geometry, state, *medium_p,
                    (step_p == NULL) ? -1 : *step_p);
        }

        if ((*medium_p != NULL) && (geometry->daughters != NULL)) {
                double step;
                struct pumas_medium * medium = *medium_p;
                if (step_p != NULL) step = *step_p;

                *medium_p = NULL;
                struct pumas_geometry * daughter;
                for (daughter = geometry->daughters; daughter != NULL;
                     daughter = daughter->next) {
                        if (daughter == exclude) continue;

                        geometry_navigate(daughter, state, medium_p, step_p,
                                          geometry, current_p);
                        if (*medium_p != NULL) break;
                        else if (step_p != NULL) {
                                if ((*step_p > 0) && (*step_p < step))
                                        step = *step_p;
                        }
                }
                if (*medium_p == NULL) {
                        *current_p = geometry;
                        *medium_p = medium;
                        if (step_p != NULL) *step_p = step;
                }
        }

        if (*medium_p == PUMAS_MEDIUM_TRANSPARENT) *medium_p = NULL;

        if ((*medium_p == NULL) && (geometry->mother != NULL) &&
            (geometry->mother != exclude)) {
                        geometry_navigate(geometry->mother, state, medium_p,
                                          step_p, geometry, current_p);
        }
}


/* Generic geometry callback */
enum pumas_step pumas_geometry_medium(struct pumas_context * context,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p)
{
        struct pumas_user_data * user_data = context->user_data;
        struct pumas_geometry * geometry = user_data->geometry.current;
        if (geometry == NULL) geometry = user_data->geometry.top;

        struct pumas_state_extended * extended = (void *)state;
        extended->geodetic.computed = 0;

        struct pumas_medium * tmp;
        geometry_navigate(geometry, state, &tmp, step_p, NULL,
                          &user_data->geometry.current);
        if (medium_p != NULL) *medium_p = tmp;

        return PUMAS_STEP_APPROXIMATE; /* XXX Exact steps for polyhedrons? */
}


static double add_global_magnet(struct pumas_state * state,
    struct pumas_locals * locals)
{
        struct pumas_state_extended * extended = (void *)state;
        struct pumas_context * context = extended->context;
        struct pumas_user_data * user_data = context->user_data;
        struct pumas_geometry * geometry = user_data->geometry.current;
        if (geometry->magnet == NULL)
                return 0;

        double magnet[3];
        const double s = geometry->magnet(geometry, state, magnet);

        int i;
        for (i = 0; i < 3; i++)
                locals->magnet[i] += magnet[i];

        return s;
}


/* Uniform medium */
static double uniform_locals(struct pumas_medium * medium,
    struct pumas_state * state, struct pumas_locals * locals)
{
        struct pumas_medium_uniform * uniform =
            (struct pumas_medium_uniform *)medium;
        memcpy(locals, &uniform->locals, sizeof *locals);

        /* Look for a global magnetic field */
        return add_global_magnet(state, locals);
}


void pumas_medium_uniform_initialise(struct pumas_medium_uniform * uniform,
    int material, double density, const double * magnet)
{
        uniform->medium.material = material;
        uniform->medium.locals = &uniform_locals;
        uniform->locals.density = density;
        if (magnet != NULL) {
                memcpy(uniform->locals.magnet, magnet,
                    sizeof uniform->locals.magnet);
        } else {
                memset(uniform->locals.magnet, 0x0,
                    sizeof uniform->locals.magnet);
        }
}


/* Medium with a density gradient */
static double gradient_locals(struct pumas_medium * medium_,
    struct pumas_state * state, struct pumas_locals * locals)
{
#define GRADIENT_MIN_PROJECTION 5E-02
#define GRADIENT_RESOLUTION 1E-02

        /* Set the magnetic field */
        struct pumas_medium_gradient * medium = (void *)medium_;
        memcpy(locals->magnet, medium->magnet, sizeof locals->magnet);
        double step = add_global_magnet(state, locals);

        /* Project onto the gradient axis */
        const double * const u = medium->gradient.direction;
        double z;
        if (medium->gradient.project != NULL) {
                z = medium->gradient.project(medium, state);
        } else {
                const double * const r = state->position;
                z = r[0] * u[0] + r[1] * u[1] + r[2] * u[2];
        }

        const double * const v = state->direction;
        double d = fabs(u[0] * v[0] + u[1] * v[1] + u[2] * v[2]);
        if (d < GRADIENT_MIN_PROJECTION)
                d = GRADIENT_MIN_PROJECTION;

        /* Compute the density and the gradient length */
        double step2;
        if (medium->gradient.type == PUMAS_MEDIUM_GRADIENT_LINEAR) {
                locals->density = (1. + (z - medium->gradient.z0) /
                    medium->gradient.lambda) * medium->gradient.rho0;
        } else {
                locals->density = medium->gradient.rho0 *
                    exp((z - medium->gradient.z0) / medium->gradient.lambda);
        }

        step2 = fabs(medium->gradient.lambda / d) * GRADIENT_RESOLUTION;
        if (step <= 0) return step2;
        else return (step < step2) ? step: step2;
}


void pumas_medium_gradient_initialise(
    struct pumas_medium_gradient * medium, int material,
    enum pumas_medium_gradient_type type, double lambda, double z0,
    double rho0, const double * magnet)
{
        medium->medium.material = material;
        medium->medium.locals = &gradient_locals;

        medium->gradient.type = type;
        medium->gradient.lambda = lambda;
        medium->gradient.z0 = z0;
        medium->gradient.rho0 = rho0;

        medium->gradient.project = NULL;
        memset(medium->gradient.direction, 0x0,
            sizeof medium->gradient.direction);

        if (magnet != NULL)
                memcpy(medium->magnet, magnet, sizeof medium->magnet);
        else
                memset(medium->magnet, 0x0, sizeof medium->magnet);

#undef GRADIENT_MIN_PROJECTION
#undef GRADIENT_RESOLUTION
}


double pumas_medium_gradient_project_altitude(
    struct pumas_medium_gradient * medium, const struct pumas_state * state)
{
#define VERTICAL_UPDATE_DISTANCE 1E+03

        struct pumas_state_extended * extended = (void *)state;
        if (!extended->geodetic.computed) {
                turtle_ecef_to_geodetic(state->position,
                                        &extended->geodetic.latitude,
                                        &extended->geodetic.longitude,
                                        &extended->geodetic.altitude);
                extended->geodetic.computed = 1;
        }

        if (state->distance >= extended->vertical.distance) {
                turtle_ecef_from_horizontal(extended->geodetic.latitude,
                                            extended->geodetic.longitude, 0, 90,
                                            extended->vertical.last);
                extended->vertical.distance = state->distance +
                                              VERTICAL_UPDATE_DISTANCE;
        }
        memcpy(medium->gradient.direction, extended->vertical.last,
               sizeof medium->gradient.direction);

        return extended->geodetic.altitude;

#undef VERTICAL_UPDATE_DISTANCE
}


void pumas_geometry_infinite_get(struct pumas_geometry * base_geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p)
{
        if (medium_p != NULL) {
                struct pumas_geometry_infinite * geometry =
                    (void *)base_geometry;
                *medium_p = geometry->medium;
        }

        if (step_p != NULL) *step_p = 0;
}


void pumas_geometry_earth_get(struct pumas_geometry * base_geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p)
{
        struct pumas_geometry_earth * earth = (void *)base_geometry;
        struct pumas_state_extended * extended = (void *)state;
        double elevation[2];
        int index[2];

        turtle_stepper_step(*earth->stepper, state->position, NULL,
            &extended->geodetic.latitude, &extended->geodetic.longitude,
            &extended->geodetic.altitude, elevation, step_p, index);
        extended->geodetic.computed = 1;

        if (medium_p != NULL) {
                if ((index[0] >= 0) && (earth->media != NULL)) {
                        if (earth->n_layers > 1) {
                                *medium_p = ((index[0] < earth->n_layers) &&
                                    (elevation[1] != DBL_MAX)) ?
                                    earth->media[index[0]] : NULL;
                        } else {
                                *medium_p = (extended->geodetic.altitude <
                                             elevation[0]) ?
                                    earth->media[0] :
                                    NULL;
                        }
                } else {
                        *medium_p = NULL;
                }
        }
}


double pumas_geometry_earth_magnet(struct pumas_geometry * base_geometry,
    struct pumas_state * state, double * magnet)
{
#define GEOMAGNET_UPDATE_DISTANCE 1E+03
        struct pumas_geometry_earth * earth = (void *)base_geometry;

        if (state->distance < earth->magnet.distance) {
                memcpy(magnet, earth->magnet.last, sizeof earth->magnet.last);
        } else {
                /* Get geodetic coordinates */
                struct pumas_geodetic_point geodetic_position;
                turtle_ecef_to_geodetic(state->position,
                    &geodetic_position.latitude, &geodetic_position.longitude,
                    &geodetic_position.altitude);

                /* Get the local frame */
                struct pumas_coordinates_transform frame;
                struct pumas_cartesian_point ecef_position = {
                    state->position[0], state->position[1], state->position[2]};
                pumas_coordinates_frame_initialise_local(&frame, &ecef_position,
                    &geodetic_position);

                /* Get the local magnetic field (ENU frame) */
                struct pumas_cartesian_vector magnet_enu = {.frame = &frame};
                gull_snapshot_field(*earth->magnet.snapshot,
                    geodetic_position.latitude, geodetic_position.longitude,
                    geodetic_position.altitude, (double *)(&magnet_enu),
                    earth->magnet.workspace);

                /* Transform back to ECEF */
                pumas_coordinates_cartesian_vector_transform(
                    &magnet_enu, NULL);

                /* Update the magnet and its history */
                memcpy(&earth->magnet.last, &magnet_enu,
                    sizeof earth->magnet.last);
                memcpy(magnet, &magnet_enu, sizeof earth->magnet.last);
                earth->magnet.distance = state->distance +
                                         GEOMAGNET_UPDATE_DISTANCE;
        }

        return GEOMAGNET_UPDATE_DISTANCE;

#undef GEOMAGNET_UPDATE_DISTANCE
}


void pumas_geometry_earth_reset(struct pumas_geometry * base_geometry)
{
        struct pumas_geometry_earth * earth = (void *)base_geometry;
        earth->magnet.distance = -1;
        memset(earth->magnet.last, 0x0, sizeof earth->magnet.last);
}


void pumas_geometry_earth_destroy(struct pumas_geometry * base_geometry)
{
        struct pumas_geometry_earth * earth = (void *)base_geometry;
        turtle_stepper_destroy(earth->stepper);
        free(*earth->magnet.workspace);
        *earth->magnet.workspace = NULL;
        gull_snapshot_destroy(earth->magnet.snapshot);
        free(base_geometry);
}


void pumas_geometry_polyhedron_get(struct pumas_geometry * geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p)
{
#define STEP_MIN 1E-05

        struct pumas_geometry_polyhedron * p = (void *)geometry;
        const double * const position = state->position;

        struct pumas_state_extended * extended = (void *)state;
        const double sgn =
            (extended->context->mode.direction == PUMAS_MODE_FORWARD)? 1 : -1;
        const double direction[3] = {sgn * state->direction[0],
                                     sgn * state->direction[1],
                                     sgn * state->direction[2]};

        double dE = -DBL_MAX, dL = DBL_MAX;
        int i, inside = 1;
        struct pumas_polyhedron_face * s;
        for (i = 0, s = p->faces; i < p->n_faces; i++, s++) {
                const double rn = (position[0] - s->origin[0]) * s->normal[0] +
                    (position[1] - s->origin[1]) * s->normal[1] +
                    (position[2] - s->origin[2]) * s->normal[2];
                if (rn > 0) inside = 0;
                const double un = direction[0] * s->normal[0] +
                    direction[1] * s->normal[1] + direction[2] * s->normal[2];
                if (fabs(un) <= FLT_EPSILON) continue;
                const double d = (rn == 0) ? 0 : -rn / un;
                if ((un > 0) && (d < dL))
                        dL = d;
                else if ((un < 0.) && (d > dE))
                        dE = d;
        }

        double step;
        struct pumas_medium * medium;
        if (inside && (dL > 0)) {
                step = (dL > STEP_MIN) ? dL : STEP_MIN;
                medium = p->medium;
        } else if (!inside && (dE > 0)) {
                step = (dE > STEP_MIN) ? dE : STEP_MIN;
                medium = NULL;
        } else {
                step = DBL_MAX;
                medium = (dL == 0) ? p->medium : NULL;
        }

        if (step_p != NULL) *step_p = step;
        if (medium_p != NULL) *medium_p = medium;

#undef STEP_MIN
}


/* Coordinates transforms */
static void cartesian_point_transform(struct pumas_cartesian_point * self,
    const struct pumas_coordinates_transform * frame)
{
        const struct pumas_coordinates_transform * initial_frame = self->frame;

        if (initial_frame != NULL) {
                const double r[3] = { self->x, self->y, self->z };
                self->x = initial_frame->translation[0] +
                          initial_frame->rotation[0][0] * r[0] +
                          initial_frame->rotation[0][1] * r[1] +
                          initial_frame->rotation[0][2] * r[2];
                self->y = initial_frame->translation[1] +
                          initial_frame->rotation[1][0] * r[0] +
                          initial_frame->rotation[1][1] * r[1] +
                          initial_frame->rotation[1][2] * r[2];
                self->z = initial_frame->translation[2] +
                          initial_frame->rotation[2][0] * r[0] +
                          initial_frame->rotation[2][1] * r[1] +
                          initial_frame->rotation[2][2] * r[2];
        }

        if (frame != NULL) {
                const double r[3] = { self->x - frame->translation[0],
                                      self->y - frame->translation[1],
                                      self->z - frame->translation[2] };
                self->x = frame->rotation[0][0] * r[0] +
                          frame->rotation[1][0] * r[1] +
                          frame->rotation[2][0] * r[2];
                self->y = frame->rotation[0][1] * r[0] +
                          frame->rotation[1][1] * r[1] +
                          frame->rotation[2][1] * r[2];
                self->z = frame->rotation[0][2] * r[0] +
                          frame->rotation[1][2] * r[1] +
                          frame->rotation[2][2] * r[2];
        }

        self->frame = (void *)frame;
}


void pumas_coordinates_cartesian_point_transform(
    struct pumas_cartesian_point * self,
    const struct pumas_coordinates_transform * frame)
{
        if (self->frame == frame) return;
        cartesian_point_transform(self, frame);
}


static void cartesian_vector_transform(struct pumas_cartesian_vector * self,
    const struct pumas_coordinates_transform * frame)
{
        const struct pumas_coordinates_transform * initial_frame =
            self->frame;

        if (initial_frame != NULL) {
                const double r[3] = { self->x, self->y, self->z };
                self->x = initial_frame->rotation[0][0] * r[0] +
                          initial_frame->rotation[0][1] * r[1] +
                          initial_frame->rotation[0][2] * r[2];
                self->y = initial_frame->rotation[1][0] * r[0] +
                          initial_frame->rotation[1][1] * r[1] +
                          initial_frame->rotation[1][2] * r[2];
                self->z = initial_frame->rotation[2][0] * r[0] +
                          initial_frame->rotation[2][1] * r[1] +
                          initial_frame->rotation[2][2] * r[2];
        }

        if (frame != NULL) {
                const double r[3] = { self->x, self->y, self->z };
                self->x = frame->rotation[0][0] * r[0] +
                          frame->rotation[1][0] * r[1] +
                          frame->rotation[2][0] * r[2];
                self->y = frame->rotation[0][1] * r[0] +
                          frame->rotation[1][1] * r[1] +
                          frame->rotation[2][1] * r[2];
                self->z = frame->rotation[0][2] * r[0] +
                          frame->rotation[1][2] * r[1] +
                          frame->rotation[2][2] * r[2];
        }

        self->frame = (void *)frame;
}


void pumas_coordinates_cartesian_vector_transform(
    struct pumas_cartesian_vector * self,
    const struct pumas_coordinates_transform * frame)
{
        if (self->frame == frame) return;
        cartesian_vector_transform(self, frame);
}


static void cartesian_from_geodetic(struct pumas_cartesian_point * self,
    const struct pumas_geodetic_point * point)
{
        turtle_ecef_from_geodetic(point->latitude, point->longitude,
                                  point->altitude, (double *)self);
}


void pumas_coordinates_cartesian_point_from_geodetic(
    struct pumas_cartesian_point * self,
    const struct pumas_geodetic_point * point)
{
        cartesian_from_geodetic(self, point);
        self->frame = NULL;
}


static void cartesian_from_spherical(void * self_, const void * point_)
{
        struct pumas_cartesian_point * self = self_;
        const struct pumas_spherical_point * point = point_;
        const double st = sin(point->theta);
        self->x = point->r * cos(point->phi) * st;
        self->y = point->r * sin(point->phi) * st;
        self->z = cos(point->theta);
}


void pumas_coordinates_cartesian_point_from_spherical(
    struct pumas_cartesian_point * self,
    const struct pumas_spherical_point * point)
{
        cartesian_from_spherical(self, point);
        self->frame = point->frame;
}


static void spherical_from_horizontal(
    struct pumas_spherical_vector * self,
    const struct pumas_horizontal_vector * vector)
{
        memcpy(self, vector, sizeof *self);
        self->theta = 0.5 * M_PI - self->theta;
        self->phi = 0.5 * M_PI - self->phi;
}


static void cartesian_from_horizontal(
    struct pumas_cartesian_vector * self,
    const struct pumas_horizontal_vector * vector)
{
        struct pumas_spherical_vector tmp;
        spherical_from_horizontal(&tmp, vector);

        cartesian_from_spherical(self, &tmp);
}


void pumas_coordinates_cartesian_vector_from_horizontal(
    struct pumas_cartesian_vector * self,
    const struct pumas_horizontal_vector * vector)
{
        cartesian_from_horizontal(self, vector);
        self->frame = vector->frame;
}


void pumas_coordinates_cartesian_vector_from_spherical(
    struct pumas_cartesian_vector * self,
    const struct pumas_spherical_vector * vector)
{
        cartesian_from_spherical(self, vector);
        self->frame = vector->frame;
}


static void spherical_from_cartesian(void * self_, const void * point_)
{
        struct pumas_spherical_point * self = self_;
        const struct pumas_cartesian_point * point = point_;
        const double rho2 = point->x * point->x + point->y * point->y;
        const double rho = sqrt(rho2);
        self->theta = atan2(rho, point->z);

        double phi;
        if (fabs(self->theta) <= FLT_EPSILON)
                self->phi = 0;
        else
                self->phi = atan2(point->y, point->x);

        self->r = sqrt(rho2 + point->z * point->z);
}


void pumas_coordinates_spherical_point_from_cartesian(
    struct pumas_spherical_point * self,
    const struct pumas_cartesian_point * point)
{
        spherical_from_cartesian(self, point);
        self->frame = point->frame;
}


void pumas_coordinates_spherical_point_from_geodetic(
    struct pumas_spherical_point * self,
    const struct pumas_geodetic_point * point)
{
        struct pumas_cartesian_point tmp;
        cartesian_from_geodetic(&tmp, point);
        spherical_from_cartesian(self, &tmp);
        self->frame = NULL;
}


void pumas_coordinates_spherical_vector_from_cartesian(
    struct pumas_spherical_vector * self,
    const struct pumas_cartesian_vector * vector)
{
        spherical_from_cartesian(self, vector);
        self->frame = vector->frame;
}


void pumas_coordinates_spherical_vector_from_horizontal(
    struct pumas_spherical_vector * self,
    const struct pumas_horizontal_vector * vector)
{
        spherical_from_horizontal(self, vector);
        self->frame = vector->frame;
}


void pumas_coordinates_geodetic_point_from_cartesian(
    struct pumas_geodetic_point * self,
    const struct pumas_cartesian_point * point)
{
        struct pumas_cartesian_point tmp;
        if (point->frame != NULL) {
                memcpy(&tmp, point, sizeof tmp);
                cartesian_point_transform(&tmp, NULL);
                point = &tmp;
        }

        turtle_ecef_to_geodetic((double *)point, &self->latitude,
                                &self->longitude, &self->altitude);
}


void pumas_coordinates_geodetic_point_from_spherical(
    struct pumas_geodetic_point * self,
    const struct pumas_spherical_point * point)
{
        struct pumas_cartesian_point tmp;
        cartesian_from_spherical(&tmp, point);

        if (point->frame != NULL)
                cartesian_point_transform(&tmp, NULL);

        turtle_ecef_to_geodetic((double *)point, &self->latitude,
                                &self->longitude, &self->altitude);
}


static void horizontal_from_spherical(
    struct pumas_horizontal_vector * self,
    const struct pumas_spherical_vector * vector)
{
        memcpy(self, vector, sizeof *self);
        self->elevation = 0.5 * M_PI - self->elevation;
        self->azimuth = 0.5 * M_PI - self->azimuth;
}


static void horizontal_from_cartesian(
    struct pumas_horizontal_vector * self,
    const struct pumas_cartesian_vector * vector)
{
        struct pumas_spherical_vector tmp;
        spherical_from_cartesian(&tmp, vector);
        horizontal_from_spherical(self, &tmp);
}


void pumas_coordinates_horizontal_vector_from_cartesian(
    struct pumas_horizontal_vector * self,
    const struct pumas_cartesian_vector * vector)
{
        horizontal_from_cartesian(self, vector);
        self->frame = vector->frame;
}


void pumas_coordinates_horizontal_vector_from_spherical(
    struct pumas_horizontal_vector * self,
    const struct pumas_spherical_vector * vector)
{
        horizontal_from_spherical(self, vector);
        self->frame = vector->frame;
}


void pumas_coordinates_horizontal_vector_transform(
    struct pumas_horizontal_vector * self,
    const struct pumas_coordinates_transform * frame)
{
        if (self->frame == frame) return;

        struct pumas_cartesian_vector tmp;
        cartesian_from_horizontal(&tmp, self);
        cartesian_vector_transform(&tmp, frame);
        horizontal_from_cartesian(self, &tmp);
        self->frame = (void *)frame;
}


void pumas_coordinates_spherical_point_transform(
    struct pumas_spherical_point * self,
    const struct pumas_coordinates_transform * frame)
{
        if (self->frame == frame) return;

        struct pumas_cartesian_point tmp;
        cartesian_from_spherical(&tmp, self);
        cartesian_point_transform(&tmp, frame);
        spherical_from_cartesian(self, &tmp);
        self->frame = (void *)frame;
}


void pumas_coordinates_spherical_vector_transform(
    struct pumas_spherical_vector * self,
    const struct pumas_coordinates_transform * frame)
{
        if (self->frame == frame) return;

        struct pumas_cartesian_vector tmp;
        cartesian_from_spherical(&tmp, self);
        cartesian_vector_transform(&tmp, frame);
        spherical_from_cartesian(self, &tmp);
        self->frame = (void *)frame;
}


void pumas_coordinates_frame_initialise_local(
    struct pumas_coordinates_transform * frame,
    const struct pumas_cartesian_point * cartesian,
    const struct pumas_geodetic_point * geodetic)
{
        /* XXX check and handle default conversions if NULL */

        frame->translation[0] = cartesian->x;
        frame->translation[1] = cartesian->y;
        frame->translation[2] = cartesian->z;

        double tmp[3];
        int i;

        turtle_ecef_from_horizontal(
            geodetic->latitude, geodetic->longitude, 90, 0, tmp);
        for (i = 0; i < 3; i++)
                frame->rotation[i][0] = tmp[i];

        turtle_ecef_from_horizontal(
            geodetic->latitude, geodetic->longitude, 0, 0, tmp);
        for (i = 0; i < 3; i++)
                frame->rotation[i][1] = tmp[i];

        turtle_ecef_from_horizontal(
            geodetic->latitude, geodetic->longitude, 0, 90, tmp);
        for (i = 0; i < 3; i++)
                frame->rotation[i][2] = tmp[i];
}

double pumas_flux_tabulation_get(
    const struct pumas_flux_tabulation * tabulation, double k, double c,
    double charge)
{
        /* Compute the interpolation indices and coefficients */
        const double dlk = log(tabulation->k_max / tabulation->k_min) /
                           tabulation->n_k;
        double hk = log(k / tabulation->k_min) / dlk;
        if ((hk < 0.) || (hk > tabulation->n_k)) return 0.;
        hk -= 0.5;
        int ik = (int)hk;
        if ((hk < 0) || (hk > tabulation->n_k - 1)) hk = 0.;
        else hk -= ik;

        const double dc = (tabulation->c_max - tabulation->c_min) /
                          tabulation->n_c;
        double hc = (c - tabulation->c_min) / dc;
        if ((hc < 0.) || (hc > tabulation->n_c)) return 0.;
        hc -= 0.5;
        int ic = (int)hc;
        if ((hc < 0) || (hc > tabulation->n_c - 1)) hc = 0.;
        else hc -= ic;

        const int ik1 = (ik < tabulation->n_k - 1) ?
            ik + 1 : tabulation->n_k - 1;
        const int ic1 = (ic < tabulation->n_c - 1) ?
            ic + 1 : tabulation->n_c - 1;
        const float * const f00 =
            tabulation->data + 2 * (ic * tabulation->n_k + ik);
        const float * const f01 =
            tabulation->data + 2 * (ic1 * tabulation->n_k + ik);
        const float * const f10 =
            tabulation->data + 2 * (ic * tabulation->n_k + ik1);
        const float * const f11 =
            tabulation->data + 2 * (ic1 * tabulation->n_k + ik1);

        /* Interpolate the flux */
        double flux = 0.;
        int i;
        for (i = 0; i < 2; i++) {
                if ((1 - 2 * i) * charge < 0) continue;

                /* Linear interpolation along cos(theta) */
                const double g0 = f00[i] * (1. - hc) + f01[i] * hc;
                const double g1 = f10[i] * (1. - hc) + f11[i] * hc;

                /* Log or linear interpolation along log(kinetic) */
                if ((g0 <= 0.) || (g1 <= 0.))
                        flux += g0 * (1. - hk) + g1 * hk;
                else
                        flux += exp(log(g0) * (1. - hk) + log(g1) * hk);
        }
        return flux;
}

/* The flux tabulation data */
#include "flux_data.c"
