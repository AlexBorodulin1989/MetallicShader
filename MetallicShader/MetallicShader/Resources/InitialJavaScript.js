setViewBackground([0.8, 0.1, 0.0]);

var projection = fovProjection(0.785398, 0.1, 100, 0.95)

systemLog(projection);

setMatrix(projection, 2);
