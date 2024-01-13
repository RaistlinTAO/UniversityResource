package message;

import main.Person;

final class TwitterSender extends MessageSender {

	public TwitterSender() {
		super(Person.TWITTER);
		// TODO Auto-generated constructor stub
	}

	@Override
	boolean onSendMessage(String from, String to, String contents) {
		try {
			Message message=Message.getMessage(from, to,contents,Person.TWITTER);
			// Email sending logic here
			System.out.println("Sending twitter message to "+message.getToAddress());
		} catch (Exception e) {
			e.printStackTrace();
			return(false);
		}
		return(true);
	}

}
