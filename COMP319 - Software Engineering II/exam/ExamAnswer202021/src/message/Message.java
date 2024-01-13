package message;

import main.Person;

abstract class Message {
	abstract void validateAddresses(String from,String to) throws Exception;
	private String fromAddress;
	private String toAddress;
	private String messageBody;
	
	Message(String from,String to,String contents) throws Exception {
		this.fromAddress=from;this.toAddress=to;this.messageBody=contents;
	}
	
	static final Message getMessage(String from,String to,String body,int preference) throws Exception {
		switch (preference) {
	    case Person.EMAIL :
	    	return(new EmailMessage(from,to,body));
	    case Person.TWITTER :
	    	return(new TwitterMessage(from,to,body));
	    case Person.SMS :
	    	return(new SMSMessage(from,to,body));
	    }
		throw new Exception("Message type not supported");
	}

	public String getFromAddress() {
		return fromAddress;
	}

	public String getToAddress() {
		return toAddress;
	}

	public String getMessageBody() {
		return messageBody;
	}
}
