setViewBackground([0.8, 0.1, 0.0]);

var projection = fovProjection(0.785398, 0.1, 100, 0.95);

setMatrix(projection, "projectionMatrix");
/*
function UpdateViewSize(width) {
    systemLog(width);
}*/

systemLog("Success perform script");

while (true) {
    systemLog("Fail");
}
