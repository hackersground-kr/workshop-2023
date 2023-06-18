import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
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
        <p className="content">Github Issue Summarizer<br></br>깃허브 레포의 정보를 <span style={{color:'#a6ff00'}}>유저이름 / 레포이름</span> 형식으로 입력해주세요.<br></br>
            <span>User name / Repo name</span>
        </p>
    )
}

function Input({ gitClassName, placeholderText }) {
    //Return input with className with "gitClassName, rounded-full hover:ring-[#a6ff00] focus:ring-[#a6ff00]"" and placehoder, style
    return(
        <input type="text" className={`${gitClassName} rounded-full ring-2 hover:ring-[#a6ff00] focus:outline-none focus:ring focus:ring-[#a6ff00]`} placeholder={placeholderText} style={{width:'180px', padding:'7px 10px', margin:'5px', color:'black'}}></input>
    );
}

function InputForm() {
    return (
        <form>
            <Input gitClassName="git-user" placeholderText="User name" />
            <Input gitClassName="git-repo" placeholderText="Repo name" />
        </form>

    )
}


function Button() {
    const navigate = useNavigate();
    //add sample data to issues
    const [issues, setIssues] = useState([]);
    const [error, setError] = useState(null);

    async function handleOnClick() {
        console.log("button clicked");
        //Get form input value git-user, git-repo
        const user = document.querySelector('.git-user').value;
        const repo = document.querySelector('.git-repo').value;
        
        //Trigger getIssues() with user & repo input 
        // const issues = getIssues(user, repo);
        if (process.env.NODE_ENV === 'development') {
            console.log(process.env.NODE_ENV);

            const sampleData = [
                { id: 1, number: 1, title: "Issue 1 for testing" , body: "Issue 1 body for testing"},
                { id: 2, number: 2, title: "Issue 2 for testing" , body: "Issue 2 body for testing"},
                { id: 3, number: 3, title: "Issue 3 for testing" , body: "Issue 3 body for testing"},
                { id: 4, number: 4, title: "Issue 4 for testing" , body: "Issue 4 body for testing"},
                { id: 5, number: 5, title: "Issue 5 for testing" , body: "Issue 5 body for testing"},
                { id: 6, number: 6, title: "Issue 6 for testing" , body: "Issue 6 body for testing"},
                { id: 7, number: 7, title: "Issue 7 for testing" , body: "Issue 7 body for testing"},
                { id: 8, number: 8, title: "Issue 8 for testing" , body: "Issue 8 body for testing"},
                { id: 9, number: 9, title: "Issue 9 for testing" , body: "Issue 9 body for testing"},
                { id: 10, number: 10, title: "Issue 10 for testing" , body: "Issue 10 body for testing"},
            ];
            //Add sample data to issues
            sampleData.forEach((data) => {
                setIssues(issues.push(data));
            });
            
        } else {
            const response = await fetch(process.env.REACT_APP_BASE_URL + process.env.REACT_APP_ISSUE_ENDPOINT + '?user=' + user + '&repository=' + repo);
        
            if (response.ok) {
                const data = await response.json();
                setIssues(data.items);
            } else if (response.status === 401) {
                setError('Unauthorized. Please log in to access GitHub issues.');
            } else if (response.status === 403) {
                setError('Forbidden. You do not have permission to access GitHub issues.');
            } else {
                setError('Error occurred while fetching GitHub issues.');
            }
        }

        //If there is error, alert error & do not navigate to /info
        if (error) {
            alert(error);
        } else {
            //Move to new path, /info with const issues
            navigate('/info', { state: { issues, user, repo } });
            console.log('Navigating to /info with state:', { issues, user, repo }); // Check if navigation is called and state is correct
        }
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
                <InputForm />
                <Button />
            </div>
        </div>
    );
}

export default Main;