//#include <gtkmm/window.h>
//#include <gtkmm/box.h>
//#include <gtkmm/button.h>
//#include <gtkmm/main.h>
//These two includes must be the very first thing on the program
#include <gtkmm.h>
#include <epoxy/gl.h>

#include "MyRTSPClient.h"
#include "FfmpegHardwareDecoder.h"
#include "FfmpegSoftwareDecoder.h"
#include "Singleton.h"
#include "VideoReceiver.h"

#include <iostream>
//#include <GL/glew.h>
//#include <GL/glx.h>
#include <thread>
#include <mutex>

//#include "OpenGLArea.h"
//#include "OpenglSmartRenderer.h"
//#include "OpenglSmartRenderer2.h"
#include "OpenglSmartRenderer3.h"
#include "NVidiaRenderer.h"
#include "NvidiaRendererEGL.h"
#include "SimpleRenderer.h"
#include "Orwell.h"
#include "SLog.h"
#include "NVDecoder.h"
SLOG_CATEGORY("main");

int main(int argc, char **argv)
{
	LOG.printImmediately(true);
	/*
	//Gtk::Main kit;
    //"NaluUtils"
	SLOG_ENABLE_CATEGORIES("main", "NVDecoder", "Decoder", "NVidiaRenderer");
	auto app = Gtk::Application::create(argc, argv, "");
    std::shared_ptr<Decoder> nvDecoder = std::make_shared<NVDecoder>(NVDecoder::NALU, Decoder::H264);
	Orwell orwell(RTSPUrl("rtsp://admin:19929394@192.168.0.103:10554/tcp/av0_1"), nvDecoder);
	Singleton::instance()->addStream("cam1", orwell);

	//TODO (VERY IMPORTANT): when Windows is created, it searches for "cam1" in Singleton.
	//It must be already setted. I must find a way to not cause problems if it's not setted yet.

	NVidiaRenderer nVidiaRenderer;
	nVidiaRenderer.setDecodedFramesFifo(orwell.decodedFramesFifo);
	auto nVidiaRendererThread = std::make_shared<std::thread>(&NVidiaRenderer::run, &nVidiaRenderer);
	//return app->run();
	return app->run(nVidiaRenderer);
	*/
	//Gtk::Main kit;
    //"NaluUtils"
	SLOG_ENABLE_CATEGORIES("main", "NVDecoder", "Decoder", "NVidiaRenderer", "NvidiaRendererEGL", "myRtspClient");
	std::string rtspUrl("rtsp://admin:19929394@192.168.0.103:10554/tcp/av0_1");
	auto rtspClient = std::make_shared<MyRTSPClient>(rtspUrl);
	auto decoder = std::make_shared<NVDecoder>(NVDecoder::NALU, Decoder::H264);
	Orwell orwell(rtspClient, decoder);
	Singleton::instance()->addStream("cam1", orwell);
	NvidiaRendererEGL nVidiaRendererEGL(1920,1080,0,0);
	nVidiaRendererEGL.setDecodedFramesFifo(orwell.decodedFramesFifo);
	auto nVidiaRendererEGLThread = std::make_shared<std::thread>(&NvidiaRendererEGL::run, &nVidiaRendererEGL);
	//TODO (VERY IMPORTANT): when Windows is created, it searches for "cam1" in Singleton.
	//It must be already setted. I must find a way to not cause problems if it's not setted yet.

	//NVidiaRenderer nVidiaRenderer;
	//nVidiaRenderer.setDecodedFramesFifo(orwell.decodedFramesFifo);
	//auto nVidiaRendererThread = std::make_shared<std::thread>(&NVidiaRenderer::run, &nVidiaRenderer);
	//return app->run();
	while(true){}
}
