package = 'pumas'
version = 'scm-1'
source = {
   url = 'git+https://github.com/niess/pumas-luajit.git'
}
description = {
   summary = 'This is Work In Progress ...',
   detailed = 'This is Work In Progress ...',
   homepage = 'https://github.com/niess/pumas-luajit',
   license = 'GNU LGPL-3.0'
}
dependencies = {
   'lua 5.1',
   'luafilesystem'
}
build = {
   type = 'builtin',
   modules = {
      pumas = 'src/pumas.lua',
      ['pumas.call'] = 'src/pumas/call.lua',
      ['pumas.clib'] = 'src/pumas/clib.lua',
      ['pumas.compat'] = 'src/pumas/compat.lua',
      ['pumas.constants'] = 'src/pumas/constants.lua',
      ['pumas.context'] = 'src/pumas/context.lua',
      ['pumas.coordinates'] = 'src/pumas/coordinates.lua',
      ['pumas.coordinates.frame'] = 'src/pumas/coordinates/frame.lua',
      ['pumas.coordinates.transform'] = 'src/pumas/coordinates/transform.lua',
      ['pumas.coordinates.type'] = 'src/pumas/coordinates/type.lua',
      ['pumas.data.elements'] = 'src/pumas/data/elements.lua',
      ['pumas.data.igrf13'] = 'src/pumas/data/igrf13.lua',
      ['pumas.data.materials'] = 'src/pumas/data/materials.lua',
      ['pumas.element'] = 'src/pumas/element.lua',
      ['pumas.enum'] = 'src/pumas/enum.lua',
      ['pumas.error'] = 'src/pumas/error.lua',
      ['pumas.flux'] = 'src/pumas/flux.lua',
      ['pumas.geometry'] = 'src/pumas/geometry.lua',
      ['pumas.geometry.base'] = 'src/pumas/geometry/base.lua',
      ['pumas.geometry.earth'] = 'src/pumas/geometry/earth.lua',
      ['pumas.geometry.infinite'] = 'src/pumas/geometry/infinite.lua',
      ['pumas.geometry.layer'] = 'src/pumas/geometry/layer.lua',
      ['pumas.geometry.polyhedron'] = 'src/pumas/geometry/polyhedron.lua',
      ['pumas.geometry.topography'] = 'src/pumas/geometry/topography.lua',
      ['pumas.header.api'] = 'src/pumas/header/api.lua',
      ['pumas.header.extensions'] = 'src/pumas/header/extensions.lua',
      ['pumas.header.gull'] = 'src/pumas/header/gull.lua',
      ['pumas.header.turtle'] = 'src/pumas/header/turtle.lua',
      ['pumas.material'] = 'src/pumas/material.lua',
      ['pumas.medium'] = 'src/pumas/medium.lua',
      ['pumas.medium.base'] = 'src/pumas/medium/base.lua',
      ['pumas.medium.gradient'] = 'src/pumas/medium/gradient.lua',
      ['pumas.medium.transparent'] = 'src/pumas/medium/transparent.lua',
      ['pumas.medium.uniform'] = 'src/pumas/medium/uniform.lua',
      ['pumas.metatype'] = 'src/pumas/metatype.lua',
      ['pumas.os'] = 'src/pumas/os.lua',
      ['pumas.pdg'] = 'src/pumas/pdg.lua',
      ['pumas.physics'] = 'src/pumas/physics.lua',
      ['pumas.physics.build'] = 'src/pumas/physics/build.lua',
      ['pumas.physics.composite'] = 'src/pumas/physics/composite.lua',
      ['pumas.physics.physics'] = 'src/pumas/physics/physics.lua',
      ['pumas.physics.tabulated'] = 'src/pumas/physics/tabulated.lua',
      ['pumas.physics.utils'] = 'src/pumas/physics/utils.lua',
      ['pumas.readonly'] = 'src/pumas/readonly.lua',
      ['pumas.recorder'] = 'src/pumas/recorder.lua',
      ['pumas.state'] = 'src/pumas/state.lua'
   },
   install = {
       lib = {
           ['pumas.?'] = 'src/pumas/libpumas_extended.so'
       }
   }
}
