package main;

public class Person {
    public Person(String sendAddress, int messagingPreference) {
		super();
		this.sendAddress = sendAddress;
		this.messagingPreference = messagingPreference;
	}
	public static final int EMAIL=1;
    public static final int SMS=2;
    public static final int TWITTER=3;
    private String sendAddress;
    public String getSendAddress() {
          return(this.sendAddress);
    }
    private int messagingPreference=0;	// Message preference
    public final int getMessagingPreference() {
           return(messagingPreference);
    }
    public Person(int preference) {
    	this.messagingPreference=preference;
    }
}
