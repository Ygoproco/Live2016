--スウィッチヒーロー
--Switch Hero
--Scripted by Eerie Code
function c30426226.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c30426226.con)
	e1:SetTarget(c30426226.tg)
	e1:SetOperation(c30426226.op)
	c:RegisterEffect(e1)
end

function c30426226.nfil(c,e)
	return not c:IsAbleToChangeControler() or c:IsImmuneToEffect(e)
end
function c30426226.con(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return tg:GetCount()>0 and og:GetCount()>0 and tg:GetCount()==og:GetCount()
		and tg:FilterCount(c30426226.nfil,nil,e)==0 and og:FilterCount(c30426226.nfil,nil,e)==0
end
function c30426226.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c30426226.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if tg:GetCount()~=og:GetCount() or tg:FilterCount(c30426226.nfil,nil,e)>0
		or og:FilterCount(c30426226.nfil,nil,e)>0 then return end
	local tc=tg:GetFirst()
	local oc=og:GetFirst()
	while tc and oc do
		Duel.SwapControl(tc,oc)
		tc=tg:GetNext()
		oc=og:GetNext()
	end
end
