float[] projMat = projectionMatrix(45.0, 0.1, 100.0, 0.5);
setMatrix(projMat, "projection");

float[] viewMat = viewMatrix(0, 0, 3);
setMatrix(viewMat, "view");

float[] translateMat = translateMatrix(0, -0.3, 0);
setMatrix(translateMat, "translate");

float[] rotateMat = rotateMatrix(0, 45, 0);
setMatrix(rotateMat, "rotate");

setViewBackground(0.5, 0.5, 0.5);

void UpdateScreenSize(float width, float height) {
    float ratio = width / height;
    logger(ratio);
    float[] projMat = projectionMatrix(45.0, 0.1, 100.0, ratio);
    resetMatrix(projMat, "projection");
}

float a = -10.0 * 2.0 + (-2.0) / 3.0;
float b = 10.0 / 3;
logger(a);
logger(b);
