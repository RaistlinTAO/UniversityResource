package message;

import main.Person;

final class EmailSender extends MessageSender {

	public EmailSender() {
		super(Person.EMAIL);
	}

	@Override
	boolean onSendMessage(String from, String to, String contents) {
		try {
			Message message=Message.getMessage(from, to,contents,Person.EMAIL);
			// Email sending logic here
			System.out.println("Sending email message to "+message.getToAddress());
		} catch (Exception e) {
			e.printStackTrace();
			return(false);
		}
		return true;
	}

}
