import { useLocation } from 'react-router-dom';
import { useState } from 'react';

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
    const [expanded, setExpanded] = useState(false); // Track expanded state
    
    const number = issue.number;
    const title = issue.title;

    //IF index is odd number, make the background color as bg-gray-800

    const sampleData = {
        "completion": "Sample data to be shown with bullet points. Still not sure how the data will come through and how I should render it."
    };

    async function handleIssueClick() {

        setExpanded(!expanded);

        if (process.env.NODE_ENV === 'development') {
            //Do not call API in local dev env.
            //Print "clicked" in the console.
            console.log("clicked");

            return sampleData.completion;
        } else {
            //Call /chat API endpoint
            const response = await fetch("/chat");

            //Call /storage API endpoint
            saveSummarizedIssues();
        }
    }

    async function saveSummarizedIssues() {
        //Save summarized completion to the storage with github issue info.
        
        //Check response and handle it. 
        //How will I let the user know that the issue has not been saved?

        //I should return the success response code.
    }

    return (
        <tr key={index}>
            <td className="px-1.5 py-6 whitespace-nowrap">{number}</td>
            <td
            className="text-left px-3 py-6"
            onClick={handleIssueClick} // Toggle expanded state
            style={{ cursor: 'pointer' }}
            >
                <div>
                    {title}
                    {expanded && (
                        <div
                            className="expanded-content"
                            style={{
                            top: '100%',
                            left: 0,
                            background: '#333',
                            color: '#fff',
                            padding: '10px',
                            margin: '10px 0',
                            borderRadius: '4px',
                            boxShadow: '0 2px 4px rgba(0, 0, 0, 0.5)',
                            }}
                        >
                            <ul>
                            <li>Hello</li>
                            <li>This was hidden before click.</li>
                            </ul>
                        </div>
                    )}
                </div>

            </td>
        </tr>
      );

}

function IssueTable({issues}) {
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 10;
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentIssues = issues.slice(indexOfFirstItem, indexOfLastItem);

    const rows = currentIssues.map((issue, index) => (
        <IssueRow key={index} issue={issue} />
    ));

    const totalPages = Math.ceil(issues.length / itemsPerPage);

    const handleNextPage = () => {
        setCurrentPage((prevPage) => prevPage + 1);
    };

    const handlePreviousPage = () => {
        setCurrentPage((prevPage) => prevPage - 1);
    };

    return (
        <div className="tableDiv">
            <table className="table-auto border-collapse w-full my-8 py-2 align-left min-w-full shadow overflow-hidden rounded-xl bg-[#333]">
                <thead className='px-10 bg-gray'>
                    <tr>
                        <th className="tracking-wider py-5">#</th>
                        <th className="text-left px-3">Issue Title</th>
                        {/* <th className="text-center">Save</th> */}
                    </tr>
                </thead>
                <tbody className="py-15">
                    {rows}
                </tbody>
            </table>
            
            <div className="pagination">
                <button className='rounded-full bg-[#a6ff00] px-3 py-1 mx-2 text-center text-black text-lg font-bold' onClick={handlePreviousPage} disabled={currentPage === 1}>
                    &lt;
                </button>
                <span>{`${currentPage} / ${totalPages}`}</span>
                <button className='rounded-full bg-[#a6ff00] px-3 py-1 mx-2 text-center text-black text-lg font-bold' onClick={handleNextPage} disabled={currentPage === totalPages}>
                    &gt;
                </button>
            </div>
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