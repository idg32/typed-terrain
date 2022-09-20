shader_type spatial;

uniform vec3 com_txt = vec3(0.1,0.1,0.1);

uniform float height_scale = 0.5;
uniform sampler2D displacement;
uniform sampler2D i_text;


varying vec2 tex_position;
varying vec2 phi;

void vertex() {
  tex_position = VERTEX.xz + com_txt.z * com_txt.y * com_txt.x;
  float height = texture(displacement, tex_position).x * (com_txt.z + com_txt.x);
  vec3 cal = mix(VERTEX,com_txt,13.0);
//  VERTEX.y += height * height_scale;
  float e = 0.146548;
  phi = vec2((e + 3.0) * texture(displacement,tex_position).x,VERTEX.z) - com_txt.x;
  e += e / phi.x;
//  tex_position = VERTEX.zx / 2.0 + height_scale;
  e /= 3.718346 * height + e / 33.0 * tex_position.x / tex_position.y - phi.y;
  VERTEX.y -= height * height_scale;
  VERTEX.yz += phi;
  VERTEX.xyz += vec3(sin(phi.x + com_txt.x),phi.y * e, texture(displacement, tex_position).z);
//  float i = 3.7156831 / phi.x - height * e + tex_position.y / mix(3.1415,phi.x,3.0) * (phi.x - e - phi.y + tex_position.x);
//  VERTEX.xz -= vec2(sin(i + 20.1), cos(e - VERTEX.y));
//  VERTEX.y += 1.0 * e / float(VERTEX_ID);
//  vec3 bl = vec3(tex_position,height);
//  VERTEX.xyz += vec3(bl.xz,texture(displacement, tex_position).y);
//  VERTEX.y /= e * phi.y;
//  VERTEX.y += sin(e - phi.x) * TIME / 120.0;
}

//void fragment() {
//	vec2 phi2 = vec2(0.341568 * texture(i_text,UV).x,COLOR.z);
//	float e = 1.146548;
//	e = e / phi2.x;
//	ALBEDO.g += e * 13.0;
//	ALBEDO.r += e;
//	float height = texture(i_text, tex_position).x;
// 	float i = 3.7156831 / phi.x - height * e + tex_position.y / mix(3.1415,phi.x,3.0) * (phi.x - e - phi.y + tex_position.x);	
//	vec3 fn = vec3((e * 3.0) * i,mix(phi.y,phi.x,e-i),height) ;
//	ALBEDO = fn;
//	ALBEDO = fn;
//	ALBEDO.xyz /= fn;
//	ALBEDO.yxz /= vec3(i / height, e / tex_position.x, phi.x);
//	ALBEDO.r *= e * 3.0;
//	ALBEDO.r /= (vec4(fn.rby, sin(tex_position.x + phi.y)) + vec4(ALBEDO,e)).g;
//	ALBEDO.bx += phi.xy;
//	ALBEDO.rb += tex_position.yx - fn.br;
//	ALBEDO.rgb += vec3(1.2,1.0,3.7);	
//}