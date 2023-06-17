import IssueRow from './IssueRow';
import { useState } from 'react';

function IssueTable({issues, user, repo}) {
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 10;
    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentIssues = issues.slice(indexOfFirstItem, indexOfLastItem);

    const rows = currentIssues.map((issue, index) => (
        <IssueRow key={index} issue={issue} user={user} repo={repo}/>
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

export default IssueTable;