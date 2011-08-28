#include <stdio.h>
#include "SDL.h"
extern "C" {
	#include "lua.h"
	#include "lauxlib.h"
}
#define PROJECT_TABLENAME "myLib"

extern "C" {
	int __declspec(dllexport) luaopen_myLib (lua_State *L);
}

static int Init_ (lua_State *L) {
	float x = luaL_checknumber(L, 1);
	float y = luaL_checknumber(L, 2);
	Init(x, y);
	return 0;
}

static int Swap_ (lua_State *L) {
	swap();
	return 0;
}

static int Clear_ (lua_State *L) {
	clear();
	return 0;
}

static int Key_ (lua_State *L) {
	int k = 0;
	int isKey = key(k);
	lua_pushnumber(L, isKey);
	lua_pushnumber(L, k);
	return 2;
}

static int Square_(lua_State *L){
	float x = luaL_checknumber(L, 1);
	float y = luaL_checknumber(L, 2);
	float w = luaL_checknumber(L, 3);
	float h = luaL_checknumber(L, 4);
	drawSquare( x, y, w, h );
	return 0;
}

static int Circle_(lua_State *L){
	float x = luaL_checknumber(L, 1);
	float y = luaL_checknumber(L, 2);
	float r = luaL_checknumber(L, 3);
	drawCircle( x, y, r );
	return 0;
}

static int Text_(lua_State * L){
	float x = luaL_checknumber(L, 1);
	float y = luaL_checknumber(L, 2);
	const char* c = luaL_checkstring(L, 3);
	drawText( x, y , c );
	return 0;
}

static int Color_(lua_State * L){
	float r = luaL_checknumber(L, 1);
	float g = luaL_checknumber(L, 2);
	float b = luaL_checknumber(L, 3);
	color( r, g, b );
	return 0;
}

static int Close_(lua_State * L)
{
	close();
	return 0;
}

int __declspec(dllexport) luaopen_myLib (lua_State *L) {
	struct luaL_reg driver[] = {
		{"init", Init_},
		{"swap", Swap_},
		{"key", Key_},
		{"clear", Clear_},
		{"square", Square_},
		{"circle", Circle_},
		{"text", Text_},
		{"color", Color_},
		{"close", Close_},
		{NULL, NULL},
	};
	luaL_openlib (L, "myLib", driver, 0);
	return 1;
}