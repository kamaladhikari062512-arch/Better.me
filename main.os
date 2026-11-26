import os, json, zipfile, textwrap, shutil
from pathlib import Path

root = Path("/mnt/data/better_me_ai")
if root.exists():
    shutil.rmtree(root)
root.mkdir(parents=True)

index = r'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#14234b"><meta name="description" content="AI-assisted personal development planner and coach">
<link rel="manifest" href="./manifest.webmanifest"><link rel="icon" href="./icon.svg">
<title>Better Me AI</title>
<style>
:root{--navy:#14234b;--blue:#315eea;--bg:#f4f6fb;--card:#fff;--ink:#172033;--muted:#69758a;--line:#e5e9f1;--green:#15845b;--red:#b42318}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
header{background:linear-gradient(130deg,#14234b,#294fc3);color:#fff;padding:20px max(16px,calc((100% - 1050px)/2)) 24px}
.headerrow{display:flex;align-items:center;justify-content:space-between;gap:12px}.eyebrow{font-size:11px;letter-spacing:1.4px;opacity:.8;font-weight:800}h1{font-size:27px;margin:8px 0 3px}.sub{font-size:13px;opacity:.82}.header-actions{display:flex;gap:8px}.lightbtn{border:0;background:#fff;color:var(--navy);border-radius:999px;padding:9px 12px;font-weight:750}
.wrap{max-width:1050px;margin:auto;padding:14px 14px 90px}.status{font-size:12px;margin-top:12px;opacity:.9}.nav{display:flex;overflow:auto;gap:7px;position:sticky;top:0;z-index:5;background:var(--bg);padding:9px 0 12px}.nav button{white-space:nowrap;border:1px solid var(--line);background:#fff;color:#46536c;border-radius:999px;padding:9px 13px;font-weight:700}.nav button.active{background:var(--navy);color:#fff;border-color:var(--navy)}
.view{display:none}.view.active{display:block}.card{background:var(--card);border:1px solid var(--line);border-radius:17px;padding:16px;margin-bottom:13px;box-shadow:0 4px 18px #182b5208}.card h2{font-size:17px;margin:0 0 12px}.muted{color:var(--muted);font-size:13px}.row{display:flex;align-items:center;justify-content:space-between;gap:10px}.row.wraprow{flex-wrap:wrap}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}.stat{background:#f5f7fc;border-radius:13px;padding:12px}.stat b{font-size:22px;display:block}.pill{background:#edf2ff;color:#2947a5;border-radius:999px;padding:4px 9px;font-size:11px;font-weight:750}
button{cursor:pointer;font:inherit}.primary,.secondary,.danger{border:0;border-radius:10px;padding:11px 14px;font-weight:750}.primary{background:var(--blue);color:white}.secondary{background:#edf2ff;color:#2444a7}.danger{background:#fff0ef;color:var(--red)}button:disabled{opacity:.5;cursor:not-allowed}
input,textarea,select{width:100%;padding:11px 12px;border:1px solid #dbe1ec;border-radius:10px;background:white;color:var(--ink);font:inherit;margin:5px 0 10px}textarea{min-height:88px;resize:vertical}label{font-size:12px;color:var(--muted);font-weight:700}
.task{display:flex;gap:10px;align-items:flex-start;padding:12px 0;border-bottom:1px solid var(--line)}.task:last-child{border:0}.task input{width:19px;height:19px;margin:2px 0;accent-color:var(--green)}.taskmain{flex:1}.taskmain strong{display:block}.taskmain small{color:var(--muted);display:block;margin-top:3px}.task.done strong{text-decoration:line-through;color:#8791a3}
.progress{height:8px;background:#e9edf5;border-radius:10px;overflow:hidden}.progress i{display:block;height:100%;background:#20a36b;width:0}.timeline{border-left:3px solid #c8d3f7;padding:1px 0 3px 13px;margin:12px 0}.timeline strong{display:block}.timeline p{font-size:13px;color:var(--muted);margin:4px 0}
.msg{padding:11px 12px;border-radius:13px;background:#f1f4fc;margin:8px 0;white-space:pre-wrap;line-height:1.5}.msg.user{background:#e9efff;margin-left:22px}.msg.ai{margin-right:22px}
.hidden{display:none!important}.small{font-size:11px}.foot{text-align:center;color:var(--muted);font-size:11px;padding:16px}.alert{padding:10px 12px;border-radius:10px;background:#fff7e8;color:#81530b;font-size:12px;margin:8px 0}
@media(min-width:700px){.grid{grid-template-columns:repeat(4,minmax(0,1fr))}.twocol{display:grid;grid-template-columns:1.2fr .8fr;gap:13px}.wrap{padding-top:18px}}
</style>
</head>
<body>
<header><div class="headerrow"><div><div class="eyebrow">YOUR PERSONAL DEVELOPMENT SYSTEM</div><h1>Better Me AI</h1><div class="sub">AI proposes. You approve. You make progress.</div></div><div class="header-actions"><button class="lightbtn" id="installBtn" hidden>Install</button><button class="lightbtn" id="accountBtn">Account</button></div></div><div class="status" id="syncStatus">Local mode · Sign in to sync across devices</div></header>
<main class="wrap">
<nav class="nav">
<button class="active" data-view="dashboard">Today</button><button data-view="planner">AI Planner</button><button data-view="coach">AI Coach</button><button data-view="skills">Skills</button><button data-view="health">Health</button><button data-view="budget">Budget</button><button data-view="review">Progress</button><button data-view="settings">Settings</button>
</nav>

<section class="view active" id="dashboard">
 <div class="card"><div class="row"><div><h2 id="hello">Your day, one step at a time</h2><div class="muted" id="todayDate"></div></div><span class="pill" id="journeyDay">DAY 1 / 180</span></div><div class="grid" style="margin-top:13px"><div class="stat"><b id="taskDone">0/0</b><span class="muted">Tasks completed</span></div><div class="stat"><b id="taskPercent">0%</b><span class="muted">Today's progress</span></div><div class="stat"><b id="streak">0</b><span class="muted">Active days</span></div><div class="stat"><b id="skillFocusStat">Excel</b><span class="muted">Current skill focus</span></div></div><div class="progress" style="margin-top:14px"><i id="todayProgress"></i></div></div>
 <div class="card"><div class="row"><h2>Today's approved plan</h2><button class="secondary" id="goPlanner">Open planner</button></div><div id="todayTasks" class="muted">No plan yet. Ask AI to prepare your day, then approve it.</div></div>
 <div class="card"><h2>One thing to remember</h2><p class="muted">Consistency matters more than intensity. If your day becomes difficult, reduce the plan instead of abandoning it.</p></div>
</section>

<section class="view" id="planner">
 <div class="card"><h2>Prepare my day with AI</h2><p class="muted">AI will use your schedule, priorities and recent progress to suggest a realistic plan. Nothing is added until you approve it.</p><label>Today's energy level</label><select id="energy"><option value="normal">Normal</option><option value="low">Low — keep it light</option><option value="high">High — I can do more</option></select><label>Today's available time outside college (hours)</label><input type="number" id="availableHours" min="0" max="12" step=".5" value="3"><label>What matters most today?</label><textarea id="todayPriority" placeholder="e.g. Finish research analysis, practise Excel formulas, exercise..."></textarea><button class="primary" id="generatePlan">Generate suggested plan</button><div id="planStatus" class="muted" style="margin-top:9px"></div></div>
 <div class="card hidden" id="proposalCard"><div class="row"><h2>AI's proposed plan</h2><span class="pill">Awaiting approval</span></div><div id="proposalTasks"></div><div class="row wraprow"><button class="primary" id="approvePlan">Approve this plan</button><button class="secondary" id="regeneratePlan">Regenerate</button><button class="danger" id="discardPlan">Discard</button></div></div>
 <div class="card"><h2>My usual schedule</h2><div id="scheduleSummary" class="muted"></div><button class="secondary" id="editSchedule">Edit schedule in Settings</button></div>
</section>

<section class="view" id="coach">
 <div class="card"><h2>Talk to your personal coach</h2><p class="muted">Ask for help with motivation, time management, study strategy, skills, fitness habits or a weekly reset.</p><div id="chatLog"><div class="msg ai">I'm here to help you take the next practical step. Tell me what happened today or what you are struggling with.</div></div><textarea id="coachInput" placeholder="For example: I wasted 3 hours scrolling and now I feel behind..."></textarea><button class="primary" id="sendCoach">Ask my coach</button><div class="muted small" id="coachStatus" style="margin-top:8px"></div></div>
</section>

<section class="view" id="skills">
 <div class="card"><h2>Skill development</h2><label>Current priority skill</label><select id="skillFocus"><option>Excel and Google Sheets</option><option>English communication</option><option>Digital marketing</option><option>Power BI and data analysis</option><option>Accounting and bookkeeping</option><option>AI productivity</option><option>Music and singing</option></select><div class="grid"><div><label>Weekly target (hours)</label><input type="number" id="skillTarget" min="1" max="40" value="5"></div><div><label>Hours completed</label><input type="number" id="skillCompleted" min="0" max="40" value="0"></div></div><label>Current learning project</label><input id="skillProject" placeholder="e.g. Build a sales dashboard in Excel"><button class="primary" id="saveSkill">Save skill goals</button></div>
 <div class="card"><h2>Six-month roadmap</h2><div class="timeline"><strong>Month 1 · Discipline and foundations</strong><p>Build a repeatable routine, practise English, start basic fitness and digital confidence.</p></div><div class="timeline"><strong>Month 2 · Excel and business fundamentals</strong><p>Formulas, tables, charts, bookkeeping and spreadsheet projects.</p></div><div class="timeline"><strong>Month 3 · Digital marketing</strong><p>Canva, content strategy, social media and a small portfolio.</p></div><div class="timeline"><strong>Month 4 · Data analysis</strong><p>Data cleaning, Excel dashboards and Power BI basics.</p></div><div class="timeline"><strong>Month 5 · Practical portfolio</strong><p>Build two demonstrable projects and seek feedback from local businesses.</p></div><div class="timeline"><strong>Month 6 · Career launch</strong><p>CV, LinkedIn, applications, outreach and a six-month review.</p></div></div>
</section>

<section class="view" id="health">
 <div class="card"><h2>Health and fitness log</h2><div class="grid"><div><label>Weight (kg)</label><input type="number" step=".1" id="weight" placeholder="Optional"></div><div><label>Sleep (hours)</label><input type="number" step=".5" id="sleep" placeholder="e.g. 7.5"></div></div><label>Movement / workout</label><input id="workout" placeholder="e.g. 15 min walk, squats and wall push-ups"><label>Nutrition note</label><textarea id="nutrition" placeholder="Meals, appetite, hydration..."></textarea><button class="primary" id="saveHealth">Save health entry</button></div>
 <div class="card"><h2>Gentle home routine</h2><ul><li>Squats: 2 sets of 8–12</li><li>Wall or knee push-ups: 2 sets of 5–10</li><li>Glute bridges: 2 sets of 10</li><li>Plank: 2 × 15–25 seconds</li><li>Easy walk and stretching</li></ul><p class="muted">Start gradually, rest when needed and do not exercise through pain or dizziness. Seek medical advice if weakness is persistent or worsening.</p></div><div class="card"><h2>Recent entries</h2><div id="healthHistory" class="muted">No entries yet.</div></div>
</section>

<section class="view" id="budget">
 <div class="card"><h2>Daily spending</h2><div class="row"><div><b style="font-size:25px">NPR 50</b><div class="muted">Your suggested daily budget</div></div><span class="pill">NEPAL</span></div><label>Amount spent today (NPR)</label><input type="number" id="spend" min="0" placeholder="0"><label>Spending note</label><input id="spendNote" placeholder="e.g. transport, food, mobile data"><button class="primary" id="saveBudget">Save spending</button><div class="row" style="margin-top:12px"><span class="muted">Remaining</span><b id="remaining">NPR 50</b></div></div><div class="card"><h2>Recent spending</h2><div id="budgetHistory" class="muted">No entries yet.</div></div>
</section>

<section class="view" id="review">
 <div class="card"><h2>Your progress report</h2><div class="grid"><div class="stat"><b id="weekRate">0%</b><span class="muted">7-day task completion</span></div><div class="stat"><b id="daysActive">0</b><span class="muted">Days with activity</span></div><div class="stat"><b id="tasksTotal">0</b><span class="muted">Tasks completed total</span></div><div class="stat"><b id="moneyTotal">NPR 0</b><span class="muted">Recorded spending</span></div></div></div><div class="card"><h2>Weekly reflection</h2><label>My biggest win</label><textarea id="winNote"></textarea><label>What got in my way?</label><textarea id="blockerNote"></textarea><label>One adjustment for next week</label><textarea id="nextNote"></textarea><button class="primary" id="saveReview">Save weekly reflection</button><button class="secondary" id="askWeekly" style="margin-left:5px">Ask AI to review my week</button><div id="weeklyResult"></div></div></section>

<section class="view" id="settings">
 <div class="card"><h2>Profile and schedule</h2><label>Your name / preferred name</label><input id="userName" placeholder="What should your coach call you?"><label>Main goal for the next six months</label><textarea id="mainGoal" placeholder="Describe the person and skills you want to develop..."></textarea><div class="grid"><div><label>College start</label><input type="time" id="collegeStart" value="11:00"></div><div><label>College end</label><input type="time" id="collegeEnd" value="17:00"></div><div><label>Wake-up time</label><input type="time" id="wakeTime" value="06:30"></div><div><label>Sleep target</label><input type="time" id="sleepTime" value="22:30"></div></div><label>Days attending college</label><input id="collegeDays" value="Sunday–Friday"><label>Daily budget (NPR)</label><input type="number" id="dailyBudget" min="0" value="50"><button class="primary" id="saveProfile">Save profile and schedule</button></div>
 <div class="card"><h2>Account and cloud sync</h2><p class="muted">Create an account to synchronize your progress between your phone and computer. Local mode continues to work without an account.</p><div id="authArea"><label>Email</label><input type="email" id="email" placeholder="you@example.com"><label>Password</label><input type="password" id="password" placeholder="At least 6 characters"><div class="row wraprow"><button class="primary" id="signUp">Create account</button><button class="secondary" id="signIn">Sign in</button><button class="danger" id="signOut" hidden>Sign out</button></div><div class="muted" id="authStatus" style="margin-top:8px"></div></div></div>
 <div class="card"><h2>App connections</h2><label>Cloudflare Worker URL</label><input id="workerUrl" placeholder="https://your-worker.your-subdomain.workers.dev"><label>Supabase project URL</label><input id="supabaseUrl" placeholder="https://xxxx.supabase.co"><label>Supabase anon / publishable key</label><input id="supabaseKey" placeholder="Public anon key (not service_role)"><button class="primary" id="saveConnections">Save connections</button><div class="alert">Never put a Gemini API key or Supabase service-role key in this app. Gemini key belongs only in Cloudflare Worker secrets.</div></div>
 <div class="card"><h2>Data management</h2><div class="row wraprow"><button class="secondary" id="exportData">Export backup</button><label class="secondary" style="display:inline-block;padding:11px 14px;border-radius:10px;cursor:pointer">Import backup<input type="file" id="importData" accept="application/json" hidden></label><button class="danger" id="resetData">Reset local data</button></div></div>
</section>
<div class="foot">Better Me AI · AI suggestions require your approval · Your progress belongs to you</div>
</main>
<script src="./app.js"></script>
</body></html>'''

appjs = r'''const $=id=>document.getElementById(id);
const STORE='betterMeAI_v1', AUTH='betterMeAuth_v1', CFG='betterMeCfg_v1';
const today=()=>new Date().toLocaleDateString('en-CA');
const defaultState={
 profile:{name:'',goal:'Become more confident, physically stronger and employable; develop English, business and digital skills.',collegeStart:'11:00',collegeEnd:'17:00',wakeTime:'06:30',sleepTime:'22:30',collegeDays:'Sunday–Friday',dailyBudget:50},
 startDate:today(), skill:{focus:'Excel and Google Sheets',target:5,completed:0,project:''},
 plans:{}, health:[], budgets:[], reviews:[], chat:[]
};
let state=loadState(), config=loadConfig(), auth=loadAuth(), proposal=null;
function loadState(){try{return {...defaultState,...JSON.parse(localStorage.getItem(STORE)||'{}')}}catch{return structuredClone(defaultState)}}
function loadConfig(){try{return JSON.parse(localStorage.getItem(CFG)||'{}')}catch{return {}}}
function loadAuth(){try{return JSON.parse(localStorage.getItem(AUTH)||'null')}catch{return null}}
function persist(){localStorage.setItem(STORE,JSON.stringify(state));render();queueSync()}
function loadConfigUI(){ $('workerUrl').value=config.workerUrl||'';$('supabaseUrl').value=config.supabaseUrl||'';$('supabaseKey').value=config.supabaseKey||''; }
function setStatus(s){$('syncStatus').textContent=s}
function escapeHtml(s=''){return String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function dayNumber(){const start=new Date(state.startDate+'T00:00:00'),now=new Date(today()+'T00:00:00');return Math.max(1,Math.min(180,Math.floor((now-start)/86400000)+1))}
function tasksForDay(d=today()){return state.plans[d]?.tasks||[]}
function calcStats(){let all=Object.values(state.plans).flatMap(p=>p.tasks||[]),done=all.filter(t=>t.done).length;let last7=Array.from({length:7},(_,i)=>{let x=new Date();x.setDate(x.getDate()-i);return x.toLocaleDateString('en-CA')});let recent=last7.flatMap(d=>tasksForDay(d));return {all,done,recent,rate:recent.length?Math.round(recent.filter(t=>t.done).length/recent.length*100):0,active:Object.keys(state.plans).filter(d=>(state.plans[d].tasks||[]).some(t=>t.done)).length}}
function render(){
 const d=today(),tasks=tasksForDay(d),done=tasks.filter(t=>t.done).length,pct=tasks.length?Math.round(done/tasks.length*100):0,stats=calcStats();
 $('todayDate').textContent=new Date().toLocaleDateString(undefined,{weekday:'long',month:'long',day:'numeric',year:'numeric'});
 $('hello').textContent=state.profile.name?`Keep going, ${state.profile.name}`:'Your day, one step at a time';
 $('journeyDay').textContent=`DAY ${dayNumber()} / 180`;$('taskDone').textContent=`${done}/${tasks.length}`;$('taskPercent').textContent=pct+'%';$('todayProgress').style.width=pct+'%';$('streak').textContent=stats.active;$('skillFocusStat').textContent=state.skill.focus.split(' ')[0];
 $('todayTasks').innerHTML=tasks.length?taskHTML(tasks,d):'No approved plan yet. Open AI Planner to prepare one.';
 $('scheduleSummary').textContent=`Wake ${state.profile.wakeTime} · College ${state.profile.collegeStart}–${state.profile.collegeEnd} (${state.profile.collegeDays}) · Sleep target ${state.profile.sleepTime}.`;
 $('skillFocus').value=state.skill.focus;$('skillTarget').value=state.skill.target;$('skillCompleted').value=state.skill.completed;$('skillProject').value=state.skill.project;
 $('healthHistory').innerHTML=state.health.slice(-5).reverse().map(x=>`<p><b>${x.date}</b> · ${x.weight||'—'} kg · ${x.sleep||'—'} h<br>${escapeHtml(x.workout||'')}</p>`).join('')||'No entries yet.';
 $('budgetHistory').innerHTML=state.budgets.slice(-7).reverse().map(x=>`<p><b>${x.date}</b> · NPR ${x.amount} · ${escapeHtml(x.note||'')}</p>`).join('')||'No entries yet.';
 let spend=state.budgets.find(x=>x.date===d)?.amount||0;$('spend').value=spend;$('remaining').textContent=`NPR ${(+state.profile.dailyBudget||50)-spend}`;
 $('weekRate').textContent=stats.rate+'%';$('daysActive').textContent=stats.active;$('tasksTotal').textContent=stats.done;$('moneyTotal').textContent='NPR '+state.budgets.reduce((a,x)=>a+(+x.amount||0),0);
 $('userName').value=state.profile.name;$('mainGoal').value=state.profile.goal;$('collegeStart').value=state.profile.collegeStart;$('collegeEnd').value=state.profile.collegeEnd;$('wakeTime').value=state.profile.wakeTime;$('sleepTime').value=state.profile.sleepTime;$('collegeDays').value=state.profile.collegeDays;$('dailyBudget').value=state.profile.dailyBudget;
 renderChat();updateAuthUI();
}
function taskHTML(tasks,date){return tasks.map((t,i)=>`<div class="task ${t.done?'done':''}"><input type="checkbox" data-date="${date}" data-i="${i}" ${t.done?'checked':''}><div class="taskmain"><strong>${escapeHtml(t.title)}</strong><small>${escapeHtml(t.time||'Flexible')} · ${escapeHtml(t.duration||'')} · ${escapeHtml(t.reason||'')}</small></div></div>`).join('')}
document.addEventListener('change',e=>{if(e.target.matches('.task input[type=checkbox]')){let d=e.target.dataset.date,i=+e.target.dataset.i;state.plans[d].tasks[i].done=e.target.checked;persist()}});
document.querySelectorAll('.nav button').forEach(b=>b.onclick=()=>showView(b.dataset.view));
function showView(id){document.querySelectorAll('.nav button').forEach(b=>b.classList.toggle('active',b.dataset.view===id));document.querySelectorAll('.view').forEach(v=>v.classList.toggle('active',v.id===id));if(id==='coach')renderChat()}
$('goPlanner').onclick=()=>showView('planner');
$('generatePlan').onclick=generatePlan;$('regeneratePlan').onclick=generatePlan;
$('discardPlan').onclick=()=>{$('proposalCard').classList.add('hidden');proposal=null};
async function generatePlan(){
 const btn=$('generatePlan');btn.disabled=true;$('planStatus').textContent='Preparing a realistic plan…';
 const context={date:today(),profile:state.profile,skill:state.skill,energy:$('energy').value,availableHours:+$('availableHours').value,priority:$('todayPriority').value,completedRecent:calcStats().done,recentPlans:Object.entries(state.plans).slice(-5).map(([date,p])=>({date,tasks:p.tasks}))};
 const fallback=makeFallbackPlan(context);
 try{
  const result=await aiRequest('plan',context);
  proposal=normalizePlan(result,fallback);
  $('planStatus').textContent='AI suggestion is ready. Review it before approving.';
 }catch(err){proposal=fallback;$('planStatus').textContent='AI unavailable: showing a practical offline draft instead. '+err.message}
 $('proposalTasks').innerHTML=taskHTML(proposal.tasks,today());$('proposalCard').classList.remove('hidden');btn.disabled=false;
}
function makeFallbackPlan(c){let h=c.profile,available=Math.max(1,c.availableHours||3),tasks=[
 {time:h.wakeTime,title:'Short home workout and freshen up',duration:'25 min',reason:'Build physical strength gradually'},
 {time:'08:00',title:'Focused skill practice: '+c.skill.focus,duration:'45 min',reason:'Build an employable skill'},
 {time:'09:00',title:'English speaking practice',duration:'15 min',reason:'Improve communication confidence'},
 {time:h.collegeStart,title:'College and BBA classes',duration:'As scheduled',reason:'Keep academic commitments'},
 {time:'18:00',title:'BBA study or research work',duration:'45 min',reason:'Maintain academic progress'},
 {time:'19:00',title:'Practical project / portfolio work',duration:'30 min',reason:'Turn learning into evidence'},
 {time:'20:00',title:'Music practice and daily reflection',duration:'20 min',reason:'Keep a creative habit and review your day'}
];if(c.energy==='low')tasks=tasks.filter((t,i)=>[1,2,3,4,6].includes(i));if(c.energy==='high')tasks.push({time:'20:30',title:'Read or learn one business concept',duration:'20 min',reason:'Broaden business understanding'});if(c.priority)tasks.unshift({time:'First available slot',title:c.priority,duration:'30–45 min',reason:'Your stated priority'});return {title:'A balanced, realistic day',tasks:tasks.slice(0,Math.max(3,Math.min(8,Math.ceil(available*1.5)+2)))}}
function normalizePlan(x,fallback){if(typeof x==='string'){try{x=JSON.parse(x)}catch{return fallback}}if(!x||!Array.isArray(x.tasks))return fallback;return {title:x.title||'Your proposed plan',tasks:x.tasks.slice(0,10).map(t=>({title:String(t.title||'Task'),time:String(t.time||'Flexible'),duration:String(t.duration||'20 min'),reason:String(t.reason||''),done:false}))}}
$('approvePlan').onclick=()=>{if(!proposal)return;state.plans[today()]={title:proposal.title,tasks:proposal.tasks.map(t=>({...t,done:false})),approvedAt:new Date().toISOString()};persist();$('proposalCard').classList.add('hidden');proposal=null;showView('dashboard');};
$('saveSkill').onclick=()=>{state.skill={focus:$('skillFocus').value,target:+$('skillTarget').value||5,completed:+$('skillCompleted').value||0,project:$('skillProject').value};persist();alert('Skill goals saved.')};
$('saveHealth').onclick=()=>{state.health.push({date:today(),weight:$('weight').value,sleep:$('sleep').value,workout:$('workout').value,nutrition:$('nutrition').value});['weight','sleep','workout','nutrition'].forEach(id=>$(id).value='');persist();alert('Health entry saved.')};
$('saveBudget').onclick=()=>{let amount=+$('spend').value||0,x=state.budgets.find(x=>x.date===today());if(x){x.amount=amount;x.note=$('spendNote').value}else state.budgets.push({date:today(),amount,note:$('spendNote').value});persist();alert('Spending saved.')};
$('saveProfile').onclick=()=>{state.profile={...state.profile,name:$('userName').value,goal:$('mainGoal').value,collegeStart:$('collegeStart').value,collegeEnd:$('collegeEnd').value,wakeTime:$('wakeTime').value,sleepTime:$('sleepTime').value,collegeDays:$('collegeDays').value,dailyBudget:+$('dailyBudget').value||50};persist();alert('Profile saved.')};
$('editSchedule').onclick=()=>showView('settings');
$('saveReview').onclick=()=>{state.reviews.push({date:today(),win:$('winNote').value,blocker:$('blockerNote').value,next:$('nextNote').value});persist();alert('Reflection saved.')};
$('askWeekly').onclick=async()=>{let c={stats:calcStats(),plans:Object.entries(state.plans).slice(-7),reviews:state.reviews.slice(-2),profile:state.profile};$('weeklyResult').textContent='Preparing review…';try{$('weeklyResult').textContent=await aiRequest('weekly',c)}catch(e){$('weeklyResult').textContent='AI unavailable: '+e.message}};
function renderChat(){$('chatLog').innerHTML=state.chat.slice(-12).map(m=>`<div class="msg ${m.role==='user'?'user':'ai'}">${escapeHtml(m.text)}</div>`).join('')||'<div class="msg ai">Tell me what is happening. We will find one practical next step.</div>'}
$('sendCoach').onclick=async()=>{let text=$('coachInput').value.trim();if(!text)return;state.chat.push({role:'user',text});$('coachInput').value='';renderChat();$('coachStatus').textContent='Thinking…';$('sendCoach').disabled=true;try{let reply=await aiRequest('coach',{message:text,profile:state.profile,skill:state.skill,stats:calcStats(),todayTasks:tasksForDay()});state.chat.push({role:'assistant',text:typeof reply==='string'?reply:JSON.stringify(reply)});$('coachStatus').textContent=''}catch(e){state.chat.push({role:'assistant',text:'I cannot reach the AI service right now. Try again later. Meanwhile, choose one small action you can finish in 10 minutes.'});$('coachStatus').textContent=e.message}state.chat=state.chat.slice(-30);persist();$('sendCoach').disabled=false;renderChat()};
async function aiRequest(mode,payload){if(!config.workerUrl)throw new Error('Add your Cloudflare Worker URL in Settings to enable AI.');let r=await fetch(config.workerUrl.replace(/\/$/,'')+'/api/'+mode,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});let data=await r.json().catch(()=>({}));if(!r.ok)throw new Error(data.error||`AI request failed (${r.status})`);return data.result??data.text??data}
$('saveConnections').onclick=()=>{config={...config,workerUrl:$('workerUrl').value.trim(),supabaseUrl:$('supabaseUrl').value.trim().replace(/\/$/,''),supabaseKey:$('supabaseKey').value.trim()};localStorage.setItem(CFG,JSON.stringify(config));alert('Connections saved.');setStatus('Connection settings saved.')};
async function authRequest(path,body){if(!config.supabaseUrl||!config.supabaseKey)throw new Error('Add Supabase URL and anon key in Settings first.');let r=await fetch(config.supabaseUrl+'/auth/v1/'+path,{method:'POST',headers:{'Content-Type':'application/json','apikey':config.supabaseKey},body:JSON.stringify(body)});let d=await r.json();if(!r.ok)throw new Error(d.msg||d.message||d.error_description||'Authentication failed');return d}
$('signUp').onclick=async()=>{try{let d=await authRequest('signup',{email:$('email').value,password:$('password').value});if(d.access_token){auth={access_token:d.access_token,refresh_token:d.refresh_token,user:d.user};saveAuth()}$('authStatus').textContent='Account created. If email confirmation is enabled, verify your email before signing in.'}catch(e){$('authStatus').textContent=e.message}};
$('signIn').onclick=async()=>{try{let d=await authRequest('token?grant_type=password',{email:$('email').value,password:$('password').value});auth={access_token:d.access_token,refresh_token:d.refresh_token,user:d.user};saveAuth();await syncNow();$('authStatus').textContent='Signed in and synced.'}catch(e){$('authStatus').textContent=e.message}};
$('signOut').onclick=()=>{auth=null;localStorage.removeItem(AUTH);updateAuthUI();setStatus('Signed out · Local data remains on this device.')};
function saveAuth(){localStorage.setItem(AUTH,JSON.stringify(auth));updateAuthUI()}
function updateAuthUI(){let signed=!!auth?.access_token;$('signOut').hidden=!signed;$('signIn').hidden=signed;$('signUp').hidden=signed;$('authStatus').textContent=signed?`Signed in as ${auth.user?.email||'your account'}`:'';if(signed)setStatus('Signed in · Cloud sync enabled');else setStatus('Local mode · Sign in to sync across devices')}
async function syncNow(){if(!auth?.access_token||!config.supabaseUrl||!config.supabaseKey)return;let url=config.supabaseUrl+'/rest/v1/user_state?on_conflict=user_id';let r=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json','apikey':config.supabaseKey,'Authorization':'Bearer '+auth.access_token,'Prefer':'resolution=merge-duplicates,return=minimal'},body:JSON.stringify({user_id:auth.user.id,payload:state,updated_at:new Date().toISOString()})});if(!r.ok)throw new Error('Cloud save failed: '+await r.text());setStatus('Cloud synced · '+new Date().toLocaleTimeString())}
let syncTimer;function queueSync(){if(!auth?.access_token)return;clearTimeout(syncTimer);syncTimer=setTimeout(()=>syncNow().catch(e=>setStatus('Sync issue: '+e.message)),1200)}
async function pullCloud(){if(!auth?.access_token)return;let r=await fetch(config.supabaseUrl+'/rest/v1/user_state?select=payload&user_id=eq.'+encodeURIComponent(auth.user.id),{headers:{'apikey':config.supabaseKey,'Authorization':'Bearer '+auth.access_token}});if(!r.ok)throw new Error('Cloud load failed');let a=await r.json();if(a[0]?.payload){state={...defaultState,...a[0].payload};localStorage.setItem(STORE,JSON.stringify(state));render()}}
$('exportData').onclick=()=>download(JSON.stringify({state,exportedAt:new Date().toISOString()},null,2),'better-me-ai-backup.json','application/json');
function download(content,name,type){let a=document.createElement('a'),u=URL.createObjectURL(new Blob([content],{type}));a.href=u;a.download=name;a.click();URL.revokeObjectURL(u)}
$('importData').onchange=async e=>{try{let x=JSON.parse(await e.target.files[0].text());state=x.state||x;persist();alert('Backup imported.')}catch{alert('Invalid backup file.')}};
$('resetData').onclick=()=>{if(confirm('Reset all personal tracker data on this device? Export a backup first.')){state=structuredClone(defaultState);persist()}};
$('accountBtn').onclick=()=>showView('settings');
let deferred;window.addEventListener('beforeinstallprompt',e=>{e.preventDefault();deferred=e;$('installBtn').hidden=false});$('installBtn').onclick=async()=>{if(deferred){deferred.prompt();await deferred.userChoice;deferred=null}else alert('Use browser menu → Install app / Add to Home screen.')};
if('serviceWorker'in navigator&&location.protocol.startsWith('http'))navigator.serviceWorker.register('./sw.js').catch(()=>{});
function boot(){loadConfigUI();render();if(auth?.access_token&&config.supabaseUrl&&config.supabaseKey)pullCloud().then(()=>setStatus('Cloud data loaded · '+new Date().toLocaleTimeString())).catch(e=>setStatus('Cloud load issue: '+e.message))}
boot();'''

worker = r'''export default {
  async fetch(request, env) {
    const origin = request.headers.get("Origin") || "";
    const allowed = (env.ALLOWED_ORIGIN || "").split(",").map(x => x.trim()).filter(Boolean);
    const corsOrigin = allowed.includes(origin) ? origin : (allowed.length ? "" : "*");
    const headers = {
      "Access-Control-Allow-Origin": corsOrigin || "null",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
      "Vary": "Origin"
    };
    if (request.method === "OPTIONS") return new Response(null, { headers });
    const url = new URL(request.url);
    if (url.pathname !== "/api/plan" && url.pathname !== "/api/coach" && url.pathname !== "/api/weekly")
      return json({ error: "Not found" }, 404, headers);
    if (request.method !== "POST") return json({ error: "POST required" }, 405, headers);
    if (!env.GEMINI_API_KEY) return json({ error: "AI service is not configured on the server." }, 503, headers);
    try {
      const body = await request.json();
      const mode = url.pathname.split("/").pop();
      const prompt = buildPrompt(mode, body);
      const model = env.GEMINI_MODEL || "gemini-3.1-flash-lite";
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${env.GEMINI_API_KEY}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          systemInstruction: { parts: [{ text: "You are Better Me, a practical, kind, realistic personal development coach for a BBA student in Nepal. Be concise, specific, encouraging but not flattering. Never shame the user. Respect low budget and college schedule. Do not diagnose health conditions. Do not create impossible schedules. The user must approve all plans." }] },
          contents: [{ role: "user", parts: [{ text: prompt }] }],
          generationConfig: { temperature: 0.65, maxOutputTokens: 1800 }
        })
      });
      const result = await response.json();
      if (!response.ok) return json({ error: result.error?.message || "Gemini request failed." }, response.status, headers);
      const text = result.candidates?.[0]?.content?.parts?.map(p => p.text || "").join("") || "";
      if (!text) return json({ error: "The AI returned an empty response." }, 502, headers);
      if (mode === "plan") {
        const cleaned = text.replace(/^```(?:json)?\s*/i, "").replace(/\s*```$/, "");
        try { return json({ result: JSON.parse(cleaned) }, 200, headers); }
        catch { return json({ result: { title: "AI suggested plan", tasks: [] }, text }, 200, headers); }
      }
      return json({ result: text }, 200, headers);
    } catch (e) {
      return json({ error: e.message || "Unexpected server error." }, 500, headers);
    }
  }
};

function buildPrompt(mode, data) {
  if (mode === "plan") return `Prepare a realistic daily plan using this context. Return ONLY valid JSON, no markdown, with this exact shape: {"title":"short title","tasks":[{"time":"HH:MM or flexible","title":"specific action","duration":"e.g. 25 min","reason":"why it matters"}]}. Include 4-7 tasks maximum, prioritize user priority, preserve college hours, include breaks and reasonable sleep. Do not schedule over college. For a low-energy day, reduce the workload. Avoid assuming commute details. Context: ${JSON.stringify(data)}`;
  if (mode === "weekly") return `Review this user's recent week. Identify 2 wins, 1 pattern to improve, and a realistic plan for next week. Use supportive plain language, bullets, no guilt. Context: ${JSON.stringify(data)}`;
  return `The user asks for personal coaching. Respond directly with empathy, then one practical next action and a small plan. Ask at most one useful question. Do not overcomplicate. Context: ${JSON.stringify(data)}`;
}
function json(obj, status, headers) {
  return new Response(JSON.stringify(obj), { status, headers: { ...headers, "Content-Type": "application/json; charset=utf-8" } });
}'''

schema = r'''-- Run this in Supabase Dashboard → SQL Editor.
-- One private JSON state row per authenticated user.
create table if not exists public.user_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.user_state enable row level security;

drop policy if exists "Users can read their own state" on public.user_state;
create policy "Users can read their own state"
on public.user_state for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own state" on public.user_state;
create policy "Users can insert their own state"
on public.user_state for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own state" on public.user_state;
create policy "Users can update their own state"
on public.user_state for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
'''

wrangler = '''name = "better-me-ai-worker"
main = "worker.js"
compatibility_date = "2026-11-25"

[vars]
GEMINI_MODEL = "gemini-3.1-flash-lite"
# Set ALLOWED_ORIGIN after publishing, e.g. https://YOURNAME.github.io
ALLOWED_ORIGIN = "https://YOURNAME.github.io"
'''
manifest = {"name":"Better Me AI","short_name":"Better Me","start_url":"./","scope":"./","display":"standalone","background_color":"#f4f6fb","theme_color":"#14234b","description":"AI-assisted personal development planner and coach","icons":[{"src":"icon-192.png","sizes":"192x192","type":"image/png"},{"src":"icon-512.png","sizes":"512x512","type":"image/png"}]}
sw = r'''const CACHE='better-me-ai-v1';
const FILES=['./','./index.html','./app.js','./manifest.webmanifest','./icon.svg','./icon-192.png','./icon-512.png'];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(FILES))));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))))));
self.addEventListener('fetch',e=>{if(e.request.method!=='GET')return;const u=new URL(e.request.url);if(u.pathname.includes('/api/'))return;e.respondWith(caches.match(e.request).then(c=>c||fetch(e.request).then(r=>{if(r.ok){let cp=r.clone();caches.open(CACHE).then(x=>x.put(e.request,cp))}return r}).catch(()=>caches.match('./index.html'))))});
'''
readme = r'''# Better Me AI — Complete starter implementation

A cross-platform installable PWA for AI-assisted daily planning, controlled task approval, coaching, and personal progress tracking.

## Architecture (free-tier friendly)
- Frontend: static HTML/CSS/JavaScript PWA, hosted on GitHub Pages.
- AI: Gemini Developer API called through a Cloudflare Worker. The API key stays server-side.
- Sync: Supabase Auth + a private JSONB row per user, protected by Row Level Security.
- Local-first: tracker works without sign-in; when signed in, state is saved to Supabase.

Free quotas and model availability can change. Gemini free-tier requests may be rate limited; do not assume unlimited use. On the free tier, Google may use submitted content to improve its products. Avoid entering sensitive personal information.

## Part A — publish the web app
1. Create a GitHub account and a new public repository named `better-me-ai`.
2. Upload `index.html`, `app.js`, `manifest.webmanifest`, `sw.js`, `icon.svg`, `icon-192.png`, and `icon-512.png` to the repository root.
3. Open repository Settings → Pages.
4. Under Build and deployment choose Deploy from a branch, branch `main`, folder `/ (root)`, then Save.
5. Wait for GitHub Pages to publish. Your URL will look like `https://YOURNAME.github.io/better-me-ai/`.
6. Open it in Chrome on Android and choose Install app / Add to Home screen. On desktop Chrome/Edge, use the install icon or browser menu.
7. The app can be used immediately in local-only mode. AI and cross-device sync need the following setup.

## Part B — enable Gemini AI securely
1. Open https://aistudio.google.com/app/apikey and create a Gemini API key.
2. Create a free Cloudflare account at https://dash.cloudflare.com/.
3. Install Node.js from https://nodejs.org/ and open Terminal / Command Prompt.
4. Install Wrangler:
   `npm install -g wrangler`
5. In this folder, open a terminal and log in:
   `wrangler login`
6. Set the Gemini key as a server-side secret (do not paste it into app.js or the browser):
   `wrangler secret put GEMINI_API_KEY`
   Paste the key when prompted.
7. Edit `wrangler.toml`: replace `https://YOURNAME.github.io` in ALLOWED_ORIGIN with the exact GitHub Pages origin (no trailing slash; e.g. `https://YOURNAME.github.io`).
8. Deploy:
   `wrangler deploy`
9. Copy the Worker URL shown, e.g. `https://better-me-ai-worker.YOURSUBDOMAIN.workers.dev`.
10. In the app Settings → App connections, paste the Worker URL and save.

If your GitHub Pages URL uses a project path, the Origin is still only `https://YOURNAME.github.io`, not the `/better-me-ai` path.

## Part C — enable account and cross-device sync
1. Create a free project at https://supabase.com/.
2. In Supabase Dashboard → SQL Editor, paste and run all contents of `supabase-schema.sql`.
3. Open Project Settings → API. Copy the Project URL and the publishable/anon key (NOT service_role).
4. In Supabase Authentication → Providers / Email, configure email sign-up as desired. Email confirmation may be enabled by default.
5. In Better Me AI → Settings → App connections, paste the Supabase URL and anon/publishable key; save.
6. In Settings → Account, create an account, verify email if requested, then sign in.
7. Your data is saved to your Supabase account after changes and can be accessed on your other device after signing in with the same account.

Important: This starter synchronizes the current app state as one JSON document. It is designed for a single user's personal tracker, not simultaneous multi-user editing. Export backups regularly.

## How to use
1. Set your name, six-month goal, college hours, wake/sleep times and daily budget in Settings.
2. Set the main skill you are learning in Skills.
3. Open AI Planner, choose energy level, available hours and today's priority.
4. Generate a proposal. Review and edit the proposal by regenerating if needed.
5. Tap Approve this plan. Only approved tasks appear in Today.
6. Tick tasks as you complete them. The dashboard and Progress report update.
7. Use AI Coach for difficult days and Weekly Review for a reset.
8. Log health, spending and skill practice.

## Important limitations
- The app does not autonomously observe your phone, browser, or offline activity. You mark tasks complete.
- It does not create calendar events or push notifications in this starter version.
- AI is called only when you press Generate, Ask my coach, or Ask AI to review my week.
- If Gemini quota is exhausted or the network is unavailable, daily planner supplies an offline fallback plan.
- AI free-tier terms, limits and available models can change. The selected model is `gemini-3.1-flash-lite`; change `GEMINI_MODEL` in `wrangler.toml` if unavailable to your project.
- Do not store sensitive health details or secrets in the app. Gemini free-tier content may be used to improve Google's products; consult current terms before use.

## Files
- `index.html` — responsive app UI
- `app.js` — planning, tasks, tracking, auth and sync
- `worker.js` — secure AI proxy
- `wrangler.toml` — Cloudflare deployment settings
- `supabase-schema.sql` — database table and row-level security
- `manifest.webmanifest`, `sw.js`, icons — install/offline PWA support
'''
files = {
"index.html": index, "app.js": appjs, "worker.js": worker,
"supabase-schema.sql": schema, "wrangler.toml": wrangler,
"manifest.webmanifest": json.dumps(manifest,indent=2),
"sw.js": sw, "README.txt": readme,
"icon.svg": '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><rect width="512" height="512" rx="110" fill="#14234b"/><path d="M120 270l92 92L395 170" fill="none" stroke="#86efac" stroke-width="42" stroke-linecap="round" stroke-linejoin="round"/></svg>'''
}
for name, content in files.items():
    (root/name).write_text(content,encoding="utf-8")

from PIL import Image, ImageDraw
for size in [192,512]:
    im=Image.new("RGB",(size,size),"#14234b"); d=ImageDraw.Draw(im)
    d.line([(size*.23,size*.52),(size*.42,size*.70),(size*.78,size*.31)],fill="#86efac",width=max(9,size//12),joint="curve")
    im.save(root/f"icon-{size}.png")

zip_path="/mnt/data/better_me_ai_complete.zip"
with zipfile.ZipFile(zip_path,"w",zipfile.ZIP_DEFLATED) as z:
    for p in root.iterdir():
        z.write(p,arcname=f"better_me_ai/{p.name}")
print(zip_path, os.path.getsize(zip_path), sorted(p.name for p in root.iterdir()))
