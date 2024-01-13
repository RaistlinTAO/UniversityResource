package message;

import main.Person;

final class SMSSender extends MessageSender {

	public SMSSender() {
		super(Person.SMS);
	}

	@Override
	boolean onSendMessage(String from, String to, String contents) {
		try {
			Message message=Message.getMessage(from, to,contents,Person.SMS);
			// SMS sending logic here
			System.out.println("Sending SMS message to "+message.getToAddress());
		} catch (Exception e) {
			e.printStackTrace();
			return(false);
		}
		return true;
	}

}
