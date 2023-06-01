import './Info.css'

function Header() {
    return (
        <div className="flex items-center">
            <img src="https://avatars.githubusercontent.com/u/133739593?s=200&v=4" className="logo" style={{margin: '0px 5px 0px 0px'}}></img>
            <h1 className="text-5xl font-bold hover:text-[#a6ff00]">hackersground</h1>
        </div>
    )
}

function Table() {
    return (
        <table class="table-auto border-collapse w-full">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Issue Title</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Issue 1 for testing</td>
                </tr>
            </tbody>
        </table>
    )
}

function Info() {
    return(
        <div className="Info">
            <Header />
            <Table />
        </div>
    );
}

export default Info;