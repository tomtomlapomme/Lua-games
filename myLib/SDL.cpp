#if defined(_WIN32)
#include <windows.h>
#endif

#include <SDL.h>
#include <gl/gl.h>
#include <math.h>

// for font only
#include "freeglut.h"

const float pi = 3.14159f;

void drawSquare( float x, float y, float width, float height )
{
	glPushMatrix();
	glTranslatef(x,y,0.0f);
	glBegin(GL_QUADS);
	glVertex2f(0.0f, 0.f);
	glVertex2f(width, 0.0f);
	glVertex2f(width, height);
	glVertex2f(0.0f, height);
	glEnd();
	glPopMatrix();
}

void drawCircle( float x, float y, float r )
{
	const float nb = 50;
	glPushMatrix();
	glTranslatef(x,y,0.0f);
	glBegin(GL_POLYGON);
	for( float i = 0; i<nb; i++)
	{
		glVertex2f(r*cos(i*2*pi/nb), r*sin(i*2*pi/nb));
	}
	glEnd();
	glPopMatrix();
}

void drawPoint( float x, float y )
{
	glBegin(GL_POINTS);
	glVertex2f(x, y);
	glEnd();
}

void color( float r, float g, float b )
{
	glColor3f(r, g, b);
	glClearColor(r, g, b, 1.f);
}

void clear()
{
 glClear(GL_COLOR_BUFFER_BIT);

 glLoadIdentity();
 glTranslatef(0.0f,0.0f,0.0f);
 glRotatef(0.0f, 0.0f, 0.0f, 1.0f);
}

void swap()
{
 SDL_GL_SwapBuffers();
}

void Init( int width, int height )
{
 SDL_Init(SDL_INIT_VIDEO);
 SDL_Surface *screen = SDL_SetVideoMode(width, height, 32, SDL_DOUBLEBUF | SDL_HWSURFACE | SDL_OPENGL);
  
 glViewport(0, 0, width, height);
 glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
 glShadeModel(GL_SMOOTH);
 glMatrixMode(GL_MODELVIEW);
 char *argv[] = {"tom"};int argc = 1;
 glutInit( &argc, argv);
}

void drawText( float x, float y, const char* text)
{
	glRasterPos3f( x, y, 0.f );
	int len = (int) strlen(text)+1;
	for (int i = 0; i < len; i++) {
		glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, text[i]);
	}
}


int key( int& key, int &x, int &y )
{	
SDL_Event event;
 
	if(SDL_PollEvent(&event)) {
		switch(event.type){
			case SDL_KEYDOWN:
				key = event.key.keysym.sym;
				return 1;
				break;
			case SDL_KEYUP:
				return 3;
				break;
			case SDL_QUIT:
				return 2;
				break;
			case SDL_MOUSEBUTTONDOWN:
				x = event.button.x;
				y = event.button.y;
				return 5;
				break;
			default:
				return 4;
				break;
		}

	}
	return 0;
}

void close()
{
	SDL_Quit();
}