float[] projMat = projectionMatrix(45.0, 0.1, 100.0, 0.5);
setMatrix(projMat, "projection");

void UpdateScreenSize(float width, float height) {
    float ratio = width / height;
    logger(ratio);
    float[] projMat = projectionMatrix(45.0, 0.1, 100.0, ratio);
    setMatrix(projMat, "projection");
}

float a = 10;
float b = 11;
logger(a);
logger(b);
