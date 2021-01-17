pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- four kinigs
-- by red-hara
-->8
-- math
function trs(v,r)
	return {
		v=v,
		r=r
	}
end

function vec(w,x,y,z)
	return {
		w=w,
		x=x,
		y=y,
		z=z
	}
end

function rot_wx(a)
	local c=cos(a)
	local s=sin(a)
	return {
		1,0,0,0,
		0,1,0,0,
		0,0,c,-s,
		0,0,s,c
	}
end

function trs_add(a,b)
	return trs(
		vec_add(a.v,rot_vec(a.r,b.v)),
		rot_mul(a.r,b.r)
	)
end

function vec_add(a,b)
	return vec(
		a.w+b.w,
		a.x+b.x,
		a.y+b.y,
		a.z+b.z
	)
end

function rot_vec(r,v)
	return vec(
		r[1]*v.w+r[5]*v.x+r[9]*v.y+r[13]*v.z,
		r[2]*v.w+r[6]*v.x+r[10]*v.y+r[14]*v.z,
		r[3]*v.w+r[7]*v.x+r[11]*v.y+r[15]*v.z,
		r[4]*v.w+r[8]*v.x+r[12]*v.y+r[16]*v.z
	)
end

function rot_mul(a,b)
	local res={
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0
	}
	for i=1,4 do
		for j=1,4 do
			for k=1,4 do
				res[i*4+j]+=a[i*4+k]*b[k*4+j]
			end
		end
	end
	return res
end
