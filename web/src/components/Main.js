import './Main.css';

function Header() {
    return (
        <div>
            <img src="https://avatars.githubusercontent.com/u/133739593?s=200&v=4" className="logo"></img>
            <h1 className="text-5xl font-bold hover:text-[#a6ff00]">hackersground</h1>
        </div>
    )
}
  
function Content() {
    return (
        <p className="content">Github Issue Summarizer.<br></br>이슈를 요약해서 보고 싶은 깃허브 레포 링크를 입력하세요.</p>
    )
}

function LinkInput() {
    return (
        <form>
            <input type="text" className="git-link rounded-full hover:ring-[#a6ff00] focus:ring-[#a6ff00]" placeholder='https://github.com/userID/repo.git' style={{width:'280px', padding:'7px 10px', color:'black'}}></input>
        </form>

    )
}

function Button() {
    function handleOnClick() {
        console.log("button clicked");
        //Move to new path, Issue.js
        window.location.href = "/info";
    }

    return (
        <button className="rounded-full bg-[#a6ff00] hover:bg-[#547c04]" onClick={handleOnClick}>
            <img src="https://sanjeevan.in/wp-content/uploads/2018/07/Right-Arrow-PNG-Transparent-Picture.png" style={{width:'35px'}}></img>
        </button>
    )
}

function Main() {
    return(
        <div className="Main">
            <Header />
            <br></br>
            <Content />
            <div className='flex items-center justify-center gap-3' style={{margin:'10px'}}> 
                <LinkInput />
                <Button />
            </div>
        </div>
    );
}

export default Main;