// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Opportunity> updateOpp = [SELECT Id FROM Opportunity WHERE Id = '006aj00000a5dATAAY'];
for (Opportunity opp : updateOpp) {
    opp.Amount = 7500;
    opp.LeadSource = 'Web';
}
update updateOpp;