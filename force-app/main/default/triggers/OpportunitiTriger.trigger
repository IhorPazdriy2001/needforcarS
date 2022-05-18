trigger OpportunitiTriger on Opportunity (after insert) {
   TakeSetsOfOpp.createTask(Trigger.new);          
}