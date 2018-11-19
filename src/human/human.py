import sys; sys.path.append('..')

import rbdyn as rbd

import human


mb, mbc, mbg, limits, visual_tf, collision_tf =\
  human.readUrdf('human', human.rootBody,
                       human.virtualJoints, [],
                       human.halfSitting)


def robot(fixed=False):
  if not fixed:
    return mb, mbc, mbg
  else:
    mbF = mbg.makeMultiBody(mbg.bodyIdByName(human.rootBody), True)
    mbcF = rbd.MultiBodyConfig(mbF)
    mbcF.zero(mbF)
    return mbF, mbcF, mbg

'''
def convexHull():
  fileByBodyName = human.stdCollisionsFiles(mb)
  return human.convexHull(fileByBodyName, mb)


def stpbvHull():
  fileByBodyName = human.stdCollisionsFiles(mb)
  return human.stpbvHull(fileByBodyName, mb)


def collisionTransforms():
  return collision_tf


def bounds():
  return human.nominalBounds(limits)


def stance():
  return human.halfSittingPose(mb), ('LeftFoot', 'RightFoot')


def forceSensors():
  return human.forceSensors


def accelerometerBody():
  return human.accelBody
'''
