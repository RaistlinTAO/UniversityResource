package main;

import message.MessageHelper;

public class Main {

	public Main() {

	}

	public static void main(String[] args) {
		Person person=new Person("coopes@liv.ac.uk",Person.TWITTER);
        MessageHelper.getInstance().sendMessage(person,"nhs@uk.gov","Message contents");
       
		

	}

}
