# robotic-arm

Purpose:
Create a Robotic Arm Controller or RAC  that could be used for a positioning
a robotic arm in 2 dimensions and employing an extender/grappler. 


RAC Movement Operations:
The RAC movement operates on a basis of processing X/Y Target co-ordinates.  
The Target X/Y co-ordinate values are set by two sets of four switches (one set forX Target, one set for Y-Target).
The Target X and Y values will becaptured andprocessed when a separate “MOTION” Push button is pressed and released.
When the MOTION button is pressed the X/Y switch values must be copied into X and Y registers. The register outputs 
are then used to enable motion towards the X/Y Target automatically and motion continues until the RAC reaches that 
Target position. If theRAC reaches its X-Target position before the Y-Target position, then motion in the X-direction
is discontinued but motion in the Y-direction continues until the Y-Target position is reached.The X/Y Targetswitchvalues
may be changed to a new set of X/Y Target co-ordinates at any time but motion to those co-ordinates will not begin until 
AFTER currentTARGET co-ordinate is reached(if in motion already) and the Motion button is pressed again.When the RAC is
not in motion, the Extender can be enabled for operation.NOTE: as mentioned earlier X/Y motion of the RAC cannot happen 
if the Extender is in its extended position.If motion is attempted while the Extender is extended the RAC must generate 
a System Fault Error and X/Y motion is to be prevented. To clear the error the Extender must be fully retracted. Then the
Extender status indicator must be updated. After this X/Y motion is permitted.

Extenderand Grappler Operation:
The Extender can be enabled to extend or retract when the RAC is not in motion. The Extender is activated by the RAC
being stopped in X/Y motion and by pressing and releasing a dedicated “EXTENDER” push-button. Pressing and releasing
it once will causethe Extendertoextendoutwards and it should continue until the FULL extension is reached. Pressing/
releasing the button again (only when in the FULL EXTENDED position)will causethe retraction inwards and it should 
continue until the FULL RETRACTIONis reached.The Extender position sequence is to be displayed on some leds[] as 
shown below:Position:leds[]Retracted: 0000Extending1:1000Extending2:1100Extending3:1110Fully Extended:1111Anytime that
the extender is NOT in its retracted position (“0000”) the status flag “Extender_Out” must be driven activeNOTE:If any
attempt is made to move the RAC to new Target co-ordinates while the Extender_Out flag is active the X/YPosition Controller
must be PREVENTEDfrom X or Y motion and a System FaultErrormust be indicated.The System Fault Error must remain active 
(locked) until the Extender is fully retracted. The Grappler is enabled onlywhen the Extender isin the Fully Extended position
(“1111”). Its operation is enabled by a dedicated“GRAPPLER”push-button. Press and Release the button for an Open or a Close operation.
The state of the Grappler must be indicated.
