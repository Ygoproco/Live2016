--Magical Hats (Anime)
--  By Shad3

local scard=c511005063

function scard.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(scard.cd)
  e1:SetTarget(scard.tg)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

function scard.cd(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp)
end

function scard.fil(c)
  return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(scard.fil,tp,LOCATION_MZONE,0,1,nil) end
  Duel.SelectTarget(tp,scard.fil,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,0)
end

function scard.sum_fil(c,e,tp)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0)
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  local loc=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if loc<1 then return end
  local gg=Duel.GetMatchingGroup(scard.sum_fil,tp,LOCATION_DECK,0,nil,e,tp)
  local sg=Group.CreateGroup()
  if gg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4001,10)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    sg:Merge(gg:Select(tp,1,loc,nil))
  end
  local sco=sg:GetCount()
  if loc-sco>0 then
    for i=1,loc-sco do
      sg:AddCard(Duel.CreateToken(tp,511005062))
    end
  end
  local stc=sg:GetFirst()
  while stc do
    local e1=Effect.CreateEffect(stc)
    if stc:IsType(TYPE_SPELL+TYPE_TRAP) then
      local te=stc:GetActivateEffect()
      if te and te:GetCode()==EVENT_FREE_CHAIN then
        local se1=Effect.CreateEffect(stc)
        se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
        se1:SetCondition(scard.mimica_cd)
        se1:SetOperation(scard.mimica_op)
        se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        stc:RegisterEffect(se1)
        if stc:IsType(TYPE_TRAP) then
          local te1=Effect.CreateEffect(stc)
          te1:SetType(EFFECT_TYPE_QUICK_F)
          te1:SetCode(EVENT_BATTLE_START)
          te1:SetRange(LOCATION_MZONE)
          te1:SetCondition(scard.mimicb_cd)
          te1:SetOperation(scard.mimicb_op)
          te1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
          te1:SetReset(RESET_EVENT+0x47c0000)
          stc:RegisterEffect(te1)
        end
        local se2=Effect.CreateEffect(stc)
        se2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        se2:SetCondition(scard.mimicc_cd)
        se2:SetCost(scard.mimicc_cs)
        se2:SetTarget(scard.mimicc_tg)
        se2:SetOperation(scard.mimicc_op)
        se2:SetProperty(bit.bor(te:GetProperty(),EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP))
        se2:SetCategory(te:GetCategory())
        se2:SetLabel(te:GetLabel())
        se2:SetLabelObject(te:GetLabelObject())
        se2:SetReset(RESET_EVENT+0x47c0000)
        se2:SetCode(511005063)
        se2:SetRange(LOCATION_SZONE)
        se2:SetCountLimit(1)
        stc:RegisterEffect(se2)
      end
    end
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
    e1:SetReset(RESET_EVENT+0x47c0000)
    stc:RegisterEffect(e1,true)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_REMOVE_RACE)
    e2:SetValue(RACE_ALL)
    stc:RegisterEffect(e2,true)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
    e3:SetValue(0xff)
    stc:RegisterEffect(e3,true)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_SET_BASE_ATTACK)
    e4:SetValue(0)
    stc:RegisterEffect(e4,true)
    local e5=e1:Clone()
    e5:SetCode(EFFECT_SET_BASE_DEFENSE)
    e5:SetValue(0)
    stc:RegisterEffect(e5,true)
    stc:SetStatus(STATUS_NO_LEVEL,true)
    stc=sg:GetNext()
  end
  Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
  if tc:IsFaceup() then
    if tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
    else
      Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
      tc:ClearEffectRelation()
    end
  end
  sg:AddCard(tc)
  Duel.ConfirmCards(1-tp,sg)
  Duel.ShuffleSetCard(sg)
end

function scard.mimica_cd(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetCurrentPhase()==PHASE_DAMAGE then
    local te=e:GetHandler():GetActivateEffect()
    local cond=te:GetCondition()
    local cost=te:GetCost()
    local targ=te:GetTarget()
    return (not cond or cond(e,tp,eg,ep,ev,re,r,rp)) and
      (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and
      (not targ or targ(e,tp,eg,ep,ev,re,r,rp,0))
  end
  return false
end

function scard.mimica_op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
  c:ResetEffect(EFFECT_CHANGE_TYPE,RESET_CODE)
  Duel.ChangePosition(c,POS_FACEUP)
  Duel.RaiseSingleEvent(c,511005063,e,REASON_DESTROY,tp,tp,0)
end

function scard.mimicb_cd(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler()~=Duel.GetAttackTarget() then return false end
  local te=e:GetHandler():GetActivateEffect()
  local cond=te:GetCondition()
  local cost=te:GetCost()
  local targ=te:GetTarget()
  return (not cond or cond(e,tp,eg,ep,ev,re,r,rp)) and
    (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and
    (not targ or targ(e,tp,eg,ep,ev,re,r,rp,0))
end

function scard.mimicb_op(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.SelectYesNo(tp,aux.Stringid(4001,9)) then return end
  local c=e:GetHandler()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
  c:ResetEffect(EFFECT_CHANGE_TYPE,RESET_CODE)
  Duel.ChangePosition(c,POS_FACEUP)
  Duel.RaiseSingleEvent(c,511005063,e,0,tp,tp,0)
  e:Reset()
end

function scard.mimicc_cd(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler()==re:GetHandler()
end

function scard.mimicc_cs(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local cost=e:GetHandler():GetActivateEffect():GetCost()
  if cost then cost(e,tp,eg,ep,ev,re,r,rp,chk) end
end

function scard.mimicc_tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local c=e:GetHandler()
  e:SetType(EFFECT_TYPE_ACTIVATE)
  local targ=c:GetActivateEffect():GetTarget()
  if targ then targ(e,tp,eg,ep,ev,re,r,rp,chk) end
  c:SetStatus(STATUS_ACTIVATED,true)
end

function scard.mimicc_op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP) and r==REASON_DESTROY then
    Duel.Destroy(c,REASON_BATTLE)
  end
  local op=c:GetActivateEffect():GetOperation()
  if op then op(e,tp,eg,ep,ev,re,r,rp) end
end