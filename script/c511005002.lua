--Champion's Faction
--[[
Notes
SetCode ("King" archetype) subject to change. Or maybe change to alt method.
]]

local scard=c511005002

function scard.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCategory(CATEGORY_SPSUMMON)
  e1:SetCondition(scard.cd)
  e1:SetTarget(scard.tg)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

if not scard.Set_King then
  scard.Set_King={ --replace when "King" archetype available
[70406920]=true,
[46700124]=true,
[89222931]=true,
[96938777]=true,
[18891691]=true,
[501000079]=true,
[49195710]=true,
[20563387]=true,
[93568288]=true,
[47387961]=true,
[19012345]=true,
[511000761]=true,
[6901008]=true,
[60990740]=true,
[511000760]=true,
[75326861]=true,
[32995007]=true,
[96381979]=true,
[23015896]=true,
[54149433]=true,
[66413481]=true,
[69000994]=true,
[96594609]=true,
[22993208]=true,
[57554544]=true,
[59388357]=true,
[80955168]=true,
[70791313]=true,
[16509093]=true,
[83986578]=true,
[3056267]=true,
[10071456]=true,
[47879985]=true,
[89959682]=true,
[62242678]=true,
[511001603]=true,
[22858242]=true,
[100000152]=true,
[91512835]=true,
[18710707]=true,
[87564352]=true,
[23756165]=true,
[50140163]=true,
[87257460]=true,
[15951532]=true,
[6214884]=true,
[22996376]=true,
[54702678]=true,
[38180759]=true,
[98287529]=true,
[69512157]=true,
[7127502]=true,
[6614221]=true,
[45121025]=true,
[5818798]=true,
[4179849]=true,
[14462257]=true,
[29155212]=true,
[55818463]=true,
[20438745]=true,
[72426662]=true,
[53375573]=true,
[44223284]=true,
[17573739]=true,
[8561192]=true,
[78651105]=true,
[19028307]=true,
[10613952]=true,
[21223277]=true,
[40732515]=true,
[23659124]=true,
[29515122]=true,
[5901497]=true,
[71411377]=true,
[11250655]=true,
[19748583]=true,
[60992364]=true,
[27337596]=true,
[61370518]=true,
[16768387]=true,
[12817939]=true,
[58206034]=true,
[85313220]=true,
[88307361]=true,
[84025439]=true,
[51371017]=true,
[86327225]=true,
[74069667]=true,
[83303851]=true,
[47198668]=true,
[8463720]=true,
[82956492]=true,
[44852429]=true,
[44186624]=true,
[15939229]=true,
[3758046]=true,
[27873305]=true,
[56619314]=true,
[92536468]=true,
[74583607]=true,
[987311]=true,
[79109599]=true,
[99426834]=true,
[30741334]=true,
[67136033]=true,
[39711336]=true,
[30646525]=true,
[70583986]=true,
[2316186]=true,
[75917088]=true,
[43791861]=true,
[20193924]=true,
[8763963]=true,
[34408491]=true,
[511001992]=true,
[511001993]=true,
[29424328]=true,
[89832901]=true,
[56907389]=true,
[24857466]=true,
[53982768]=true,
[5309481]=true,
[75675029]=true,
[69455834]=true,
[82213171]=true,
[45425051]=true,
[28290705]=true,
[64514622]=true,
[22910685]=true,
[511001914]=true,
[511000141]=true,
[511001690]=true
  }
end

--Main effect

function scard.cd(e,tp,eg,ep,ev,re,r,rp)
  local c=Duel.GetAttackTarget()
  return c and scard.Set_King[c:GetCode()] --and c:IsFaceup()
end

function scard.fil(c,e,tp)
  return scard.Set_King[c:GetCode()] and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and Duel.IsExistingMatchingCard(scard.fil,tp,LOCATION_DECK,0,3,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,3,tp,LOCATION_DECK)
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
  local g=Duel.GetMatchingGroup(scard.fil,tp,LOCATION_DECK,0,nil,e,tp)
  if g:GetCount()<3 then return end
  local c=e:GetHandler()
  local lbl=c:GetFieldID()
  Duel.NegateAttack()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg=g:Select(tp,3,3,nil)
  local tc=sg:GetFirst()
  while tc do
    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    local e1=Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    tc:RegisterFlagEffect(511005002,RESET_EVENT+0x1fe0000,0,1,lbl)
    tc=sg:GetNext()
  end
  Duel.SpecialSummonComplete()
  sg:KeepAlive()
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCountLimit(1)
  e2:SetLabel(lbl)
  e2:SetLabelObject(sg)
  e2:SetCondition(scard.des_cd)
  e2:SetOperation(scard.des_op)
  Duel.RegisterEffect(e2,tp)
end

--End Phase Destruction effect

function scard.des_fil(c,lbl)
  return lbl==c:GetFlagEffectLabel(511005002)
end

function scard.des_cd(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  if g:IsExists(scard.des_fil,1,nil,e:GetLabel()) then return true end
  g:DeleteGroup()
  e:Reset()
  return false
end

function scard.des_op(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  local tg=g:Filter(scard.des_fil,nil,e:GetLabel())
  Duel.Destroy(tg,REASON_EFFECT)
end