//
// function: logoutCometChat()
// purpose: Logs user out of the CometChat service and removes all of their user listeners
//
const logoutCometChat = () => {
  // Get list of users
  const users = document.getElementsByName('user-select');
  // Remove the user listeners for the user's friends
  users.forEach(u => CometChat.removeUserListener(u.id));
  // console.log("Removed user listeners");
  // Log out of CometChat
  CometChat.logout();
  // console.log("Logged out of CometChat");
}
