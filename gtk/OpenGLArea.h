#ifndef _EVG_OPEN_GL_AREA_
#define _EVG_OPEN_GL_AREA_

#include <gtkmm/drawingarea.h>
#include "VideoReceiver.h"
#include "Program.h"
#include "Frame.h"
#include <GL/glew.h>
#include <GL/glx.h>

class OpenGLArea : public Gtk::DrawingArea, public VideoReceiver
{
  public:
	OpenGLArea();
	unsigned char *buffer[3] = {0};
	virtual void init(){};
	virtual int receiveVideo(Frame *frame) = 0;

	void on_realize();
	bool on_draw(const Cairo::RefPtr<Cairo::Context> &);
	bool on_configure_event(GdkEventConfigure *event);

	virtual void glInit() = 0;
	virtual void glDraw() = 0;

  protected:
	bool firstFrameReceived = false;
	Program program;

  private:
	void on_glx_init();
	Display *xdisplay;
	GLXDrawable drawable;
	GLXContext context;
};

#endif
