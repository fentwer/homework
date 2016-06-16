Title: Gesture Phase Segmentation


Relevant Information:

   --- Gesture Phase Segmentation consists in a temporal segmentation of gestures, performed by gesture researchers in
       order to preprocess videos for further analysis. The description of gesture phase segmentation problem may be found 
       in MADEO et al. (2013a) and MADEO et al. (2013b).

   --- The dataset is composed by seven videos recorded using Microsoft Kinect sensor. Three different users were asked
       to read three comic strips and to tell the stories in front of the sensor. Using Microsoft Kinect, we have obtained:
       (a) a image of each frame, identified by a timestamp; (b) a text file containing positions (coordinates x, y, z) of
       six articulation points -- left hand, right hand, left wrist, right wrist, head and spine, with each line in the file
       corresponding to a frame and identified by a timestamp. The images enabled a manual segmentation of each file by a 
       specialist, providing a ground truth for classification.

   --- The dataset is organized in 14 files: 7 raw files and 7 processed files, one for each video which compose the dataset.
       The name of the file refers to each video: the letter corresponds to the user (a, b, c) and the number corresponds to 
       the story (1, 2, 3). The raw files contain the information obtained from Microsoft Kinect, described above. The processed 
       file contains vectorial and scalar velocity and acceleration of left hand, right hand, left wrist, and right wrist. These 
       measures were obtained after normalizing positions of hand and wrists considering the position of head and spine, and 
       using a displacement equal to 3 in order to measure velocity, as described in MADEO et al. (2013c).


Number of Instances: 

	a1 - 1743 frames
	a2 - 1260 frames
	a3 - 1830 frames
	b1 - 1069 frames
	b3 - 1420 frames
	c1 - 1107 frames
	c3 - 1444 frames


Number of Attributes: 

	Raw files (*_raw): 	  18 numeric attributes (double) and a timestamp (integer).
	Processed files (*_va3):  32 numeric attributes (double).
	A feature vector with up to 51 numeric attributes can be generated with the two files mentioned above.


Attribute Information:

   Raw files:

   1. lhx - Position of left hand (x coordinate)
   2. lhy - Position of left hand (y coordinate)
   3. lhz - Position of left hand (z coordinate)
   4. rhx - Position of right hand (x coordinate)
   5. rhy - Position of right hand (y coordinate)
   6. rhz - Position of right hand (z coordinate)
   7. hx - Position of head (x coordinate)
   8. hy - Position of head  (y coordinate)
   9. hz - Position of head  (z coordinate)
   10. sx - Position of spine (x coordinate)
   11. sy - Position of spine (y coordinate)
   12. sz - Position of spine (z coordinate)
   13. lwx - Position of left wrist (x coordinate)
   14. lwy - Position of left wrist (y coordinate)
   15. lwz - Position of left wrist (z coordinate)
   16. rwx - Position of right wrist (x coordinate)
   17. rwy - Position of right wrist (y coordinate)
   18. rwz - Position of right wrist (z coordinate)
   19. timestamp - 


   Processed files:

   1. Vectorial velocity of left hand (x coordinate)
   2. Vectorial velocity of left hand (y coordinate)
   3. Vectorial velocity of left hand (z coordinate)
   4. Vectorial velocity of right hand (x coordinate)
   5. Vectorial velocity of right hand (y coordinate)
   6. Vectorial velocity of right hand (z coordinate)
   7. Vectorial velocity of left wrist (x coordinate)
   8. Vectorial velocity of left wrist (y coordinate)
   9. Vectorial velocity of left wrist (z coordinate)
   10. Vectorial velocity of right wrist (x coordinate)
   11. Vectorial velocity of right wrist (y coordinate)
   12. Vectorial velocity of right wrist (z coordinate)
   13. Vectorial acceleration of left hand (x coordinate)
   14. Vectorial acceleration of left hand (y coordinate)
   15. Vectorial acceleration of left hand (z coordinate)
   16. Vectorial acceleration of right hand (x coordinate)
   17. Vectorial acceleration of right hand (y coordinate)
   18. Vectorial acceleration of right hand (z coordinate)
   19. Vectorial acceleration of left wrist (x coordinate)
   20. Vectorial acceleration of left wrist (y coordinate)
   21. Vectorial acceleration of left wrist (z coordinate)
   22. Vectorial acceleration of right wrist (x coordinate)
   23. Vectorial acceleration of right wrist (y coordinate)
   24. Vectorial acceleration of right wrist (z coordinate)
   25. Scalar velocity of left hand
   26. Scalar velocity of right hand
   27. Scalar velocity of left wrist
   28. Scalar velocity of right wrist
   29. Scalar velocity of left hand
   30. Scalar velocity of right hand
   31. Scalar velocity of left wrist
   32. Scalar velocity of right wrist


Missing Attribute Values: None

THERE ARE TOTALLY 5 DIFFERENT KINDS OF GESTURES. Ñ 5 CLUSTERS Ñ 
THE FIVE GESTURES ARE: Hold Preparation Rest Retraction Stroke