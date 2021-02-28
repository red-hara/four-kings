pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
-- four kings
-- by red-hara
-->8
-- math

-- transform with translation
-- and rotation
function trs(v,r)
	return {
		v=v,
		r=r
	}
end

-- vector with x, y and z
function vec(w,x,y,z)
	return {
		w=w,
		x=x,
		y=y,
		z=z
	}
end

-- rotation with w and x
-- consistent
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

function rot_wy(a)
	local c=cos(a)
	local s=sin(a)
	return {
		1,0,0,0,
		0,c,0,s,
		0,0,1,0,
		0,-s,0,c
	}
end

function rot_wz(a)
	local c=cos(a)
	local s=sin(a)
	return {
		1,0,0,0,
		0,c,-s,0,
		0,s,c,0,
		0,0,0,1
	}
end

function rot_xy(a)
	local c=cos(a)
	local s=sin(a)
	return {
	 c,0,0,s,
	 0,1,0,0,
	 0,0,1,0,
	 -s,0,0,c
	}
end

-- combine two transforms
function trs_add(a,b)
	return trs(
		vec_add(a.v,rot_vec(a.r,b.v)),
		rot_mul(a.r,b.r)
	)
end

-- apply transform to vector
function trs_app(t,v)
	return vec_add(
	 t.v,
		rot_vec(t.r,v)
	)
end

-- add two vectors
function vec_add(a,b)
	return vec(
		a.w+b.w,
		a.x+b.x,
		a.y+b.y,
		a.z+b.z
	)
end

-- rotate vector
function rot_vec(r,v)
	return vec(
		r[1]*v.w+r[5]*v.x+r[9]*v.y+r[13]*v.z,
		r[2]*v.w+r[6]*v.x+r[10]*v.y+r[14]*v.z,
		r[3]*v.w+r[7]*v.x+r[11]*v.y+r[15]*v.z,
		r[4]*v.w+r[8]*v.x+r[12]*v.y+r[16]*v.z
	)
end

-- combine two rotations
function rot_mul(a,b)
	local res={
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0
	}
	for i=0,3 do
		for j=0,3 do
			for k=0,3 do
				res[1+i*4+j]+=a[1+i*4+k]*b[1+k*4+j]
			end
		end
	end
	return res
end
-->8
-- graphics

function wrfm(v,i)
	local w={
		v=v,
		i=i
	}
	function w.draw(t,c)
		for i in all(w.i) do
			local s=trs_app(t,w.v[i[1]])
			local e=trs_app(t,w.v[i[2]])
			line(
				s.x,
				s.y,
				e.x,
				e.y,
				c
			)
		end
	end
	return w
end

function ptn(v)
	local p={v=v}
	function p.draw(t,c)
		local v=trs_app(t,p.v)
		pset(v.x,v.y,c)
	end
	return p
end
-->8
-- main

function _init()
	camera(-64,-64)
	cube=wrfm(
		{
			vec(20,20,20,20),
			vec(20,20,20,-20),
			vec(20,20,-20,-20),
			vec(20,20,-20,20),
			vec(20,-20,20,20),
			vec(20,-20,20,-20),
			vec(20,-20,-20,-20),
			vec(20,-20,-20,20),
			vec(-10,10,10,10),
			vec(-10,10,10,-10),
			vec(-10,10,-10,-10),
			vec(-10,10,-10,10),
			vec(-10,-10,10,10),
			vec(-10,-10,10,-10),
			vec(-10,-10,-10,-10),
			vec(-10,-10,-10,10)
		},
		{
			{1,2},{2,3},{3,4},{4,1},
			{5,6},{6,7},{7,8},{8,5},
			{1,5},{2,6},{3,7},{4,8},
			{9,10},{10,11},{11,12},{12,9},
			{13,14},{14,15},{15,16},{16,13},
			{9,13},{10,14},{11,15},{12,16}
		}
	)
end

function _draw()
	cls()
	tr=trs(
		vec(0,0,0,0),
		rot_mul(
			rot_mul(
				rot_xy(t()/2),
				rot_wz(t()/4)
			),
			rot_wy(t()/6)
		)
	)
	cube.draw(tr,7)
end
