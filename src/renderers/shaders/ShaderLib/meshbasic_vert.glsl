#ifdef INSTANCED
	attribute vec3 offset;
	attribute vec3 iColor;
	attribute float iScale;
	attribute vec4 orientation;
#endif
#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

vec3 applyQuaternionToVector( vec4 q, vec3 v ){
	return v + 2.0 * cross( q.xyz, cross( q.xyz, v ) + q.w * v );
}

void main() {

	#include <uv_vertex>
	#include <uv2_vertex>
	#include <color_vertex>

	#ifdef INSTANCED
		#ifdef USE_COLOR
			vColor.xyz = color.xyz;
		#endif
	#endif

	#include <skinbase_vertex>

	#ifdef USE_ENVMAP

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

	#endif

	#include <begin_vertex>

	#ifdef INSTANCED
		transformed *= iScale;
		vec3 vPosition = applyQuaternionToVector(orientation, transformed);
	#endif
	
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#ifndef INSTANCED
		#include <project_vertex>
	#endif
	#ifdef INSTANCED
		vec4 mvPosition = modelViewMatrix * vec4( offset + vPosition, 1.0 );

		gl_Position = projectionMatrix * mvPosition;
	#endif
	#include <logdepthbuf_vertex>

	#include <worldpos_vertex>
	#include <clipping_planes_vertex>
	#include <envmap_vertex>
	#include <fog_vertex>

}
