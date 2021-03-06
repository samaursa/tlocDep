set(BOX_2D_PATH   Box2D_v2.2.1)

set(
  BOX_2D_SOURCE
  ${BOX_2D_PATH}/License.txt 
  ${BOX_2D_PATH}/Box2D/Box2D.h 
  ${BOX_2D_PATH}/Box2D/Collision/b2BroadPhase.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2BroadPhase.h 
  ${BOX_2D_PATH}/Box2D/Collision/b2CollideCircle.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2CollideEdge.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2CollidePolygon.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2Collision.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2Collision.h 
  ${BOX_2D_PATH}/Box2D/Collision/b2Distance.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2Distance.h 
  ${BOX_2D_PATH}/Box2D/Collision/b2DynamicTree.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2DynamicTree.h 
  ${BOX_2D_PATH}/Box2D/Collision/b2TimeOfImpact.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/b2TimeOfImpact.h 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2ChainShape.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2ChainShape.h 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2CircleShape.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2CircleShape.h 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2EdgeShape.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2EdgeShape.h 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2PolygonShape.cpp 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2PolygonShape.h 
  ${BOX_2D_PATH}/Box2D/Collision/Shapes/b2Shape.h 
  ${BOX_2D_PATH}/Box2D/Common/b2BlockAllocator.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2BlockAllocator.h 
  ${BOX_2D_PATH}/Box2D/Common/b2Draw.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2Draw.h 
  ${BOX_2D_PATH}/Box2D/Common/b2GrowableStack.h 
  ${BOX_2D_PATH}/Box2D/Common/b2Math.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2Math.h 
  ${BOX_2D_PATH}/Box2D/Common/b2Settings.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2Settings.h 
  ${BOX_2D_PATH}/Box2D/Common/b2StackAllocator.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2StackAllocator.h 
  ${BOX_2D_PATH}/Box2D/Common/b2Timer.cpp 
  ${BOX_2D_PATH}/Box2D/Common/b2Timer.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Body.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Body.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2ContactManager.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2ContactManager.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Fixture.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Fixture.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Island.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2Island.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2TimeStep.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2World.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2World.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2WorldCallbacks.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/b2WorldCallbacks.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2CircleContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2CircleContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2Contact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2Contact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ContactSolver.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2ContactSolver.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2PolygonContact.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Contacts/b2PolygonContact.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2DistanceJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2DistanceJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2FrictionJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2FrictionJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2GearJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2GearJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2Joint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2Joint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2MouseJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2MouseJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2PrismaticJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2PrismaticJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2PulleyJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2PulleyJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2RevoluteJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2RevoluteJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2RopeJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2RopeJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2WeldJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2WeldJoint.h 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2WheelJoint.cpp 
  ${BOX_2D_PATH}/Box2D/Dynamics/Joints/b2WheelJoint.h 
  ${BOX_2D_PATH}/Box2D/Rope/b2Rope.cpp 
  ${BOX_2D_PATH}/Box2D/Rope/b2Rope.h
  )

#Copy files
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/Box2D_v2.2.1/Box2D 
  DESTINATION ${TLOC_DEP_INSTALL_PATH}/include/Box2D 
  FILE_PERMISSIONS OWNER_READ
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.cpp")

# Add the Box2D library
include_directories(
  ${BOX_2D_PATH}
  )

add_library(
  Box2D STATIC
  ${BOX_2D_SOURCE}
  )

set_platform_specific_properties(Box2D)
