package message;

final class EmailMessage extends Message {

	public EmailMessage(String from, String to, String contents) throws Exception {
		super(from, to, contents);
		validateAddresses(from,to);		
	}

	@Override
	void validateAddresses(String from, String to) throws Exception {
		// TODO Auto-generated method stub

	}

}
