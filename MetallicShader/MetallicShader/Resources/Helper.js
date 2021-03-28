function fovProjection(fov, near, far, aspect) {
    var y = 1 / Math.tan(fov * 0.5);
    var x = y / aspect;
    var z = far / (far - near);
    
    var matArr = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
    matArr[0] = [x, 0, 0, 0];
    matArr[1] = [0, y, 0, 0];
    matArr[2] = [0, 0, z, 1];
    matArr[3] = [0, 0, z * -near, 0];
    
    return matArr;
}
