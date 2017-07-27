fetch("https://api.github.com/repos/sbaildon/resume/releases/latest")
.then(resp => resp.json())
.then(function(data) {
	const download_url = data.assets[0].browser_download_url;
	document.getElementsByClassName("resume")[0].href = download_url;

}).catch(function(err) {
	console.log("Failed to update resume url");
});
