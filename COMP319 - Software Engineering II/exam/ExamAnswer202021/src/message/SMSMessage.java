package message;

final class SMSMessage extends Message {

	public SMSMessage(String from, String to, String contents) throws Exception {
		super(from, to, contents);
		validateAddresses(from, to);		
	}
	@Override
	void validateAddresses(String from, String to) throws Exception {
		// TODO Validate SMS messages
	}
}
