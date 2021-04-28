float w = getScreenWidth();
float h = getScreenHeight();
float rat = w / h;

float[] projMat = projectionMatrix(45.0, 0.1, 100.0, rat);
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

float b = 10.0 / 3;
float a = -b * 2.0 + (-2.0) / b;

logger(a);
logger(b);
