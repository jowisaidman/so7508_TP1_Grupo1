function isRunning() {  
  ps -ef | grep ".*$1.*" | grep -v grep  
}