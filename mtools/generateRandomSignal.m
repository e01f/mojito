clear;

randSeed = 58989;
fTest = 8999;
delay = 1/fTest;

simLength = 10/fTest;
sampleInterval = simLength/1000;
fMax = 1/sampleInterval / 2;
fprintf('signal bandwidth: %2.1fHz\n', fMax);
sampleTimes = 0:sampleInterval:simLength;
numZeros = ceil(delay / sampleInterval);

sigin1 = 5 * sin(sampleTimes(ceil(delay / sampleInterval) + 1:end) / (1 / fTest) * 2 * pi);
sigin = [zeros(1, numZeros) sigin1];
sigout1 = awgn(sigin1, 10, 0, randSeed);
sigout = [zeros(1, numZeros) sigout1];

cla;
hold on;
plot(sampleTimes, sigout)
plot(sampleTimes, sigin)

fn = sprintf('C:/Users/Alexander/Documents/BA/mojito/problems/zcd/detRandomSig-%d-%dHz.dat', randSeed, fTest);

fileID = fopen(fn, 'w');
fprintf(fileID, '%f %f\n', [sampleTimes; sigout]);
fclose(fileID);