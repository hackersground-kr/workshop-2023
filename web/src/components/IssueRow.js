import { useState } from 'react';
import { v4 as uuidv4 } from 'uuid';

function IssueRow({issue, index, user, repo}) {
    const [expandedBody, setExpandedBody] = useState(false); // Track expanded state
    const [body, setBody] = useState(null); // Store body in state

    const [expandedSummary, setExpandedSummary] = useState(false); // Track expanded state
    const [summary, setSummary] = useState(null); // Store summary in state

    const [saveStatus, setSaveStatus] = useState(null); // Track expanded state
    const [storageData, setStorageData] = useState({
        id: '',
        issueId: null,
        issueNumber: null,
        title: '',
        body: '',
        summary: '',
    });
    
    const id = issue.id;
    const number = issue.number;
    const title = issue.title;

    //IF index is odd number, make the background color as bg-gray-800

    const sampleData = {
        "body": "Sample data to be shown with bullet points. Still not sure how the data will come through and how I should render it."
    };

    async function handleIssueClick() {

        setExpandedBody(!expandedBody);

        if (process.env.NODE_ENV === 'development') {
            //Do not call API in local dev env.
            //Print "clicked" in the console.
            console.log("clicked");
            setBody(sampleData.body);
            console.log(body);
            //setExpandedSummary(true);
            //setSummary("Sample summary data");
            //setSaveStatus("Saved");

        } else {
            //Call issue/id API endpoint
            const response = await fetch(process.env.REACT_APP_BASE_URL + process.env.REACT_APP_ISSUE_ENDPOINT + '/' + number + '?user=' + user + '&repository=' + repo);

            const data = await response.json();
            setBody(data.body); 
        }
    }

    async function summarizeIssue() {

        setExpandedSummary(!expandedSummary);

        //Summarize the issue body
        const response = await fetch(process.env.REACT_APP_BASE_URL + process.env.REACT_APP_CHAT_ENDPOINT, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(),
        });

        const summary = await response.json();
        setSummary(summary.completion); 
    }

    async function saveSummarizedIssues() {

        //Save summarized completion to the storage with github issue info.
        const response = await fetch(process.env.REACT_APP_BASE_URL + process.env.REACT_APP_ISSUE_ENDPOINT, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(),
        });

        const randomUUID = uuidv4();
        setStorageData({
            id: randomUUID,
            issueId: id,
            issueNumber: number,
            title: title,
            body: body,
            summary: summary,
        });

        const storageResponse = await response.json();

        //If the storageData and storageResponse are same, then set saveStatus to true.
        if (storageData === storageResponse) {
            setSaveStatus("✅ 성공적으로 저장 되었습니다");
        } else {
            setSaveStatus("❌ 저장에 실패했습니다. 에러코드: " + storageResponse.message);
        }

    }


    return (
        <>
        <tr key={index}>
            <td className="px-1.5 py-6 whitespace-nowrap">{number}</td>
            <td className="text-left px-3 py-6">
                <div>
                    <span onClick={handleIssueClick} style={{ cursor: 'pointer' }} className="hover:underline decoration-[#a6ff00]">
                    {title}
                    </span>
                </div>
            </td>
        </tr>
        {expandedBody && (
            <tr>
                <td colSpan="2" className="text-left px-5">
                    <div className="expanded-content" 
                        style={{background: '#21252b',
                                color: '#fff',
                                padding: '10px',
                                borderRadius: '4px',
                                boxShadow: '0 2px 4px rgba(0, 0, 0, 0.5)',}}>
                    {body}
                    <br></br>
                        <div className='text-right my-3'>
                            <button onClick={summarizeIssue} className='rounded-full bg-[#a6ff00] px-3 py-1 mx-1 text-center text-black text-sm font-bold'>요약하기</button>
                                {expandedSummary && 
                                <div className='text-left'>
                                    <span className="by-5" style={{color: '#d19a66', padding: '10px 4px', borderRadius: '10px', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.5)'}} >🤌 OpenAI가 생성한 이슈 요약 내용</span>
                                    <br></br>
                                    <div className='my-5 mx-2'>{summary}</div>
                                </div>}
                            <button onClick={saveSummarizedIssues} className='rounded-full bg-[#a6ff00] px-3 py-1 mx-1 text-center text-black text-sm font-bold'>저장하기</button>
                                <div className='text-left'>
                                    <span className='underline decoration-[#db686f]' style={{padding: '10px 4px'}}> {saveStatus} </span>
                                </div>
                        </div>
                    </div>
                </td>
            </tr>
        )}
        </>
      );

}

export default IssueRow;