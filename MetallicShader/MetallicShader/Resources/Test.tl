float helloFunc(string strParam) {
    logger(strParam);
}
float[] projMat = projectionMatrix(45.0, 0.1, 100.0, 0.5);
setMatrix(projMat, "projection");
float[] arr = [0.5, 0.5, 0.5];
float r = 0.5;
float g = 0.5;
float b = testFunc();
logger(projMat);
setViewBackground(r, g, b);
logger("Script executed");
helloFunc("Funct executed");
int i = 5 + 2 + 3 * (3 + 2);
logger(i);
