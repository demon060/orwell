#include "SLog.h"
std::shared_ptr<SLog::ThreadSafeQueue<SLog::Message>> SLog::SLogInterface::logMessages = std::make_shared<ThreadSafeQueue<Message>>();
std::shared_ptr<SLog::UnorderedSetConfig> SLog::SLog::allowTheseCategories = std::make_shared<UnorderedSetConfig>();
SLog::LoggerThread SLog::SLog::loggerThread(SLog::SLog::logMessages, SLog::allowTheseCategories);