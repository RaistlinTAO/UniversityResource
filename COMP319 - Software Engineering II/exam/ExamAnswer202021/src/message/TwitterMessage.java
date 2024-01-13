package message;

final class TwitterMessage extends Message {

	public TwitterMessage(String from, String to, String contents) throws Exception {
		super(from, to, contents);
		validateAddresses(from, to);
	}

	@Override
	void validateAddresses(String from, String to) throws Exception {
		// TODO Validate twitter addresses

	}

}
