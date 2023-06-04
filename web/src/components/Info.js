import { useLocation } from 'react-router-dom';

import './Info.css'

function Header() {
    return (
        <div className="flex items-center">
            <img src="https://avatars.githubusercontent.com/u/133739593?s=200&v=4" className="logo" style={{margin: '0px 5px 0px 0px'}}></img>
            <h1 className="text-5xl font-bold hover:text-[#a6ff00]">hackersground</h1>
        </div>
    );
}

function RepoInfo({user, repo}) {
    return (
        <div className='flex' style={{margin:'5px'}}>
            <img src="https://icon-library.com/images/github-icon-white/github-icon-white-6.jpg" alt="GH-logo" style={{marginLeft:'10px', height: '20px', wdith: 'auto',  marginRight: '5px'}}></img>
            <a href="user.com">{user} / {repo}</a>
        </div>
    );
}

function NewRepo() {
    return (
        <div className='flex' style={{margin:'5px'}}>
            <a href="/" style={{marginLeft:'10px'}}>새로운 레포 연결하기</a>
        </div>
    )
}

function IssueRow({issue, index}) {
    const number = issue.number;
    const title = issue.title;

    return (
        <tr key={index}>
            <td>{number}</td>
            <td>{title}</td>
        </tr>
    );

}

function IssueTable({issues}) {
    const rows = [];
    
    issues.forEach((issue, index) => {
        rows.push(
            <IssueRow key={index} issue={issue} />
        );
    });

    return (
        <div className="tableDiv py-2 align-left inline-block min-w-full shadow overflow-hidden sm:rounded-lg bg-gray-900">

            <table className="table-auto border-collapse w-full">
                <thead className=''>
                    <tr>
                        <th>#</th>
                        <th>Issue Title</th>
                    </tr>
                </thead>
                <tbody>
                    {rows}
                </tbody>
            </table>
        
        </div>
    );
}

function Info() {
    const location = useLocation();
    const { issues, user, repo } = location.state;

    return(
        <div className="Info">
            <Header />
            <RepoInfo user={user} repo={repo} />
            <NewRepo />
            <IssueTable issues={issues} />
        </div>
    );
}

export default Info;