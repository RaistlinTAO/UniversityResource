package message;

abstract class MessageSender {
	int messageType;
	MessageSender nextSender=null;
	static MessageSender lastSender; // first in chain
	MessageSender(int messageType) {
		this.messageType=messageType;
		if (lastSender==null) { // construct linked list
			lastSender=this;
		} else {
			lastSender.nextSender=this;lastSender=this;
		}
	}
	final void sendMessage(int messageType,String from,String to,String contents) {
	     if (messageType==this.messageType) {
	    	 boolean ok=onSendMessage(from,to,contents);
	    	 if (ok) return;
	     }
	     this.nextSender.sendMessage(messageType, from, to, contents);
	     
	}
	abstract boolean onSendMessage(String from, String to, String contents);
}
