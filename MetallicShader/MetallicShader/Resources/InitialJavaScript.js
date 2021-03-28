setViewBackground([0.8, 0.1, 0.0]);

var transitionMatrix = math.identity(4);

var trMatArr = transitionMatrix.valueOf()
trMatArr[0][0] = 0.5;
trMatArr[1][1] = 0.5;

systemLog(trMatArr);

setMatrix(trMatArr, 2);
