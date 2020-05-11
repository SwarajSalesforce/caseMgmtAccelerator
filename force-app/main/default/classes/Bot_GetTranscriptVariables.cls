public without sharing class Bot_GetTranscriptVariables {
    public class TranscriptInput {
    @InvocableVariable(required=true)
    public ID routableID;
  }
  
  public class VisitorNameOutput {
    @InvocableVariable(required=true)
    public String contactId;
  }

  @InvocableMethod(label='Get Contact Id')
  public static List<VisitorNameOutput> getUserName(List<TranscriptInput> transcripts) {

    List<VisitorNameOutput> names = new List<VisitorNameOutput>();
  
    for (TranscriptInput transcript : transcripts) {
    
      // Query for the transcript record based on the ID
      LiveChatTranscript transcriptRecord = [SELECT Name,contactid
                                             FROM LiveChatTranscript 
                                             WHERE Id = :transcript.routableID 
                                             LIMIT 1];
      VisitorNameOutput nameData = new VisitorNameOutput();
      nameData.contactId = transcriptRecord.contactId;
      names.add(nameData);
    }
    
    return names;
  }
}
