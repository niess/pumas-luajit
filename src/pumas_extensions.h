#include "gull.h"
#include "pumas.h"
#include "turtle.h"

/* Data container for a random stream */
struct pumas_random {
        int index;
#define MT_PERIOD 624
        unsigned long buffer[MT_PERIOD];
};

/* Wrapper for geometries */
struct pumas_geometry {
        void (*get)(struct pumas_geometry *, struct pumas_state *,
            struct pumas_medium **, double *);
        double (*magnet)(struct pumas_geometry *, struct pumas_state *,
            double *);
        void (*reset)(struct pumas_geometry *);
        void (*destroy)(struct pumas_geometry *);

        struct pumas_geometry * mother;
        struct pumas_geometry * daughters;
        struct pumas_geometry * next;
};

/* A transparent medium, e.g. for a bounding box */
extern struct pumas_medium * PUMAS_MEDIUM_TRANSPARENT;

/* Layout of the user data section */
struct pumas_user_data {
        struct {
                struct pumas_geometry * top;
                struct pumas_geometry * current;
                void (*callback)(struct pumas_geometry *, struct pumas_state *,
                    struct pumas_medium *, double); /* User callback for
                                                     * debug
                                                     */
        } geometry;
        struct pumas_random random;
};

/* Forward errors */
void pumas_error_initialise(void);
void pumas_error_clear(void);
const char * pumas_error_get(void);

/* Set the MT initial state */
void pumas_random_initialise(
    struct pumas_context * context, unsigned long seed);

/* Uniform pseudo random distribution from a Mersenne Twister */
double pumas_random_uniform01(struct pumas_context * context);

/* Extended state  with a ref to the processing context */
struct pumas_state_extended {
        struct pumas_state base;
        struct pumas_context * context;

        struct {
                int computed;
                double latitude;
                double longitude;
                double altitude;
        } geodetic;

        struct {
                double distance;
                double last[3];
        } vertical;
};

void pumas_state_extended_reset(struct pumas_state_extended * state,
    struct pumas_context * context);

/* A uniform medium */
struct pumas_medium_uniform {
        struct pumas_medium medium;
        struct pumas_locals locals;
};

void pumas_medium_uniform_initialise(struct pumas_medium_uniform * uniform,
    int material, double density, const double * magnet);

/* A medium with a density gradient */
enum pumas_medium_gradient_type {
        PUMAS_MEDIUM_GRADIENT_LINEAR = 0,
        PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
};

struct pumas_medium_gradient {
        struct pumas_medium medium;
        double magnet[3];

        struct {
                enum pumas_medium_gradient_type type;
                double lambda;
                double z0;
                double rho0;

                double direction[3];
                double (* project)(struct pumas_medium_gradient * medium,
                                   const struct pumas_state * state);
        } gradient;
};

void pumas_medium_gradient_initialise(
    struct pumas_medium_gradient * medium, int material,
    enum pumas_medium_gradient_type type, double lambda, double z0,
    double rho0, const double * magnet);

double pumas_medium_gradient_project_altitude(
    struct pumas_medium_gradient * medium, const struct pumas_state * state);

/* Setters and getters for the geometry */
struct pumas_geometry * pumas_geometry_get(struct pumas_context * context);

void pumas_geometry_set(
    struct pumas_context * context, struct pumas_geometry * geometry);

void pumas_geometry_destroy(struct pumas_context * context);

void pumas_geometry_reset(struct pumas_context * context);

void pumas_geometry_push(struct pumas_geometry * geometry,
    struct pumas_geometry * daughter);

/* Generic geometry callback for PUMAS */
enum pumas_step pumas_geometry_medium(struct pumas_context * context,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p);

/* Per context data for the infinite geometry */
struct pumas_geometry_infinite {
        struct pumas_geometry base;
        struct pumas_medium * medium;
};

/* Geometry getter for a single medium of infinite extension */
void pumas_geometry_infinite_get(struct pumas_geometry * geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p);

/* Per context data for the Earth geometry */
struct pumas_geometry_earth {
        struct pumas_geometry base;

        struct turtle_stepper * stepper[1];
        struct pumas_medium ** media;
        int n_layers;

        struct {
                double * workspace[1];
                struct gull_snapshot * snapshot[1];
                double distance;
                double last[3];
        } magnet;
};

/* Getters for an Earth geometry */
void pumas_geometry_earth_get(struct pumas_geometry * geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p);

double pumas_geometry_earth_magnet(struct pumas_geometry * geometry,
    struct pumas_state * state, double * magnet);

/* Initialiser for the Earth geometry */
void pumas_geometry_earth_reset(struct pumas_geometry * geometry);

/* Finaliser for the Earth geometry */
void pumas_geometry_earth_destroy(struct pumas_geometry * geometry);

/* Data for the Polyhedron geometry */
struct pumas_polyhedron_face {
        double origin[3];
        double normal[3];
};

struct pumas_geometry_polyhedron {
        struct pumas_geometry base;
        struct pumas_medium * medium;

        int n_faces;
        struct pumas_polyhedron_face faces[];
};

/* Getter for a Polyhedron geometry */
void pumas_geometry_polyhedron_get(struct pumas_geometry * geometry,
    struct pumas_state * state, struct pumas_medium ** medium_p,
    double * step_p);

/* Coordinates objects */
struct pumas_coordinates_unitary_transformation {
    double translation[3];
    double matrix[3][3];
};

struct pumas_cartesian_point {
    double x, y, z;
    struct pumas_coordinates_unitary_transformation * frame;
};

struct pumas_cartesian_vector {
    double x, y, z;
    struct pumas_coordinates_unitary_transformation * frame;
};

struct pumas_spherical_point {
    double r, theta, phi;
    struct pumas_coordinates_unitary_transformation * frame;
};

struct pumas_spherical_vector {
    double norm, theta, phi;
    struct pumas_coordinates_unitary_transformation * frame;
};

struct pumas_geodetic_point {
    double latitude, longitude, altitude;
};

struct pumas_horizontal_vector {
    double norm, elevation, azimuth;
    struct pumas_coordinates_unitary_transformation * frame;
};

/* Coordinates transforms */
void pumas_coordinates_cartesian_point_transform(
    struct pumas_cartesian_point * self,
    const struct pumas_coordinates_unitary_transformation * frame);

void pumas_coordinates_cartesian_vector_transform(
    struct pumas_cartesian_vector * self,
    const struct pumas_coordinates_unitary_transformation * frame);

void pumas_coordinates_horizontal_vector_transform(
    struct pumas_horizontal_vector * self,
    const struct pumas_coordinates_unitary_transformation * frame);

void pumas_coordinates_spherical_point_transform(
    struct pumas_spherical_point * self,
    const struct pumas_coordinates_unitary_transformation * frame);

void pumas_coordinates_spherical_vector_transform(
    struct pumas_spherical_vector * self,
    const struct pumas_coordinates_unitary_transformation * frame);

void pumas_coordinates_cartesian_point_from_geodetic(
    struct pumas_cartesian_point * self,
    const struct pumas_geodetic_point * point);

void pumas_coordinates_cartesian_point_from_spherical(
    struct pumas_cartesian_point * self,
    const struct pumas_spherical_point * point);

void pumas_coordinates_cartesian_vector_from_horizontal(
    struct pumas_cartesian_vector * self,
    const struct pumas_horizontal_vector * vector);

void pumas_coordinates_cartesian_vector_from_spherical(
    struct pumas_cartesian_vector * self,
    const struct pumas_spherical_vector * vector);

void pumas_coordinates_geodetic_point_from_cartesian(
    struct pumas_geodetic_point * self,
    const struct pumas_cartesian_point * point);

void pumas_coordinates_geodetic_point_from_spherical(
    struct pumas_geodetic_point * self,
    const struct pumas_spherical_point * point);

void pumas_coordinates_horizontal_vector_from_cartesian(
    struct pumas_horizontal_vector * self,
    const struct pumas_cartesian_vector * vector);

void pumas_coordinates_horizontal_vector_from_spherical(
    struct pumas_horizontal_vector * self,
    const struct pumas_spherical_vector * vector);

void pumas_coordinates_spherical_point_from_cartesian(
    struct pumas_spherical_point * self,
    const struct pumas_cartesian_point * point);

void pumas_coordinates_spherical_point_from_geodetic(
    struct pumas_spherical_point * self,
    const struct pumas_geodetic_point * point);

void pumas_coordinates_spherical_vector_from_cartesian(
    struct pumas_spherical_vector * self,
    const struct pumas_cartesian_vector * vector);

void pumas_coordinates_spherical_vector_from_horizontal(
    struct pumas_spherical_vector * self,
    const struct pumas_horizontal_vector * vector);

/* Local frame initialiser */
void pumas_coordinates_frame_initialise_local(
    struct pumas_coordinates_unitary_transformation * frame,
    const struct pumas_cartesian_point * cartesian,
    const struct pumas_geodetic_point * geodetic);

/* Flux tabulations */
struct pumas_flux_tabulation {
        int n_k;
        int n_c;
        int n_h;
        double k_min;
        double k_max;
        double c_min;
        double c_max;
        double h_min;
        double h_max;
        float data[];
};

double pumas_flux_tabulation_get(
    const struct pumas_flux_tabulation * tabulation, double k, double c,
    double h, double charge);

extern struct pumas_flux_tabulation * pumas_flux_tabulation_data[1];
