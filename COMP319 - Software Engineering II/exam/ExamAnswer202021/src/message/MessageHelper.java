package message;

import main.Person;

/**
 * Singleton for interface
 * @author Admin
 *
 */
public class MessageHelper {
    private MessageSender firstSender;
    private static MessageHelper instance=null;
    public static synchronized MessageHelper getInstance() {
    	if (instance==null) {
    		instance=new MessageHelper();
    	} 
    	return(instance);
    }
	private MessageHelper() {
		// construct chain of responsibility 
		firstSender=new SMSSender(); // first in list		
		MessageSender sender=new EmailSender();
		sender=new TwitterSender();		
	}
	
	public void sendMessage(Person person,String from,String contents) {
		firstSender.sendMessage(person.getMessagingPreference(), from,person.getSendAddress(), contents);
	}
}
