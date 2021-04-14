float[] projMat = projectionMatrix(45.0, 0.1, 100.0, 0.5);
float[] arr = [0.5, 0.5, 0.5];
float r = 0.5;
float g = 0.5;
float b = testFunc();
logger(projMat);
setViewBackground(r, g, b);
logger("Script executed");
