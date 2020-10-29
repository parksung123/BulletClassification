# Using Deep Learning for Classifying Types of Bullets  
# Introduction
At war or at demilitarized zones, it is important to distinguish between the allies' and enemies' gunshots. One way to make this possible is by determining the bullets the gun was used with. 

# Project Description
In this project, using the audio recordings of 200+ bullet audio, I parsed the audio data into individual round, then further processing the data by detecting the location of the shockwave (sound created from travelling faster than the speed of sound) of the bullet.
**Then, I applied transfer learning using SqueezeNet to classify two types of bullets: 5.56mm and 7.62mm.** As CNN, SqueezeNet was used to train on wavelet-based scalogram images of the shockwaves of bullets. These scalograms were converted from the shockwave data of each bullet audio.

Due to a lack of data, I was forced to test the accuracy of the model by using the train data which is 36% of the entire test data. Using only the new 78 test data, the network reached accuracy of approximately **97.4%**. As further work, I would be interested in creating a real-time audio processing code that can classify the bullet on-site since that would prove much more useful in war-related scenarios.

# Personal Context
This was a personal side project done while I interned at Jain Technology in South Korea. One of the many things they specialize in is the research and development of military systems.

# Help and References
I was inspired by "MATLAB: Classify Time Series Using Wavelet Analysis and Deep Learning" and received help from many MATLAB Q&As.

