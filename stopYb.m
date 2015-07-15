yb = Youbot('youbot2');
yb.BaseVelocity(0,0,degtorad(5));
pause;
yb.BaseVelocity(0,0,degtorad(-5));
pause;
yb.Stop;
yb.StowArm;
